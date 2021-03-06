module MCollective
  class ClassList < Chef::Handler

    def report
      generate_classlist
      generate_facts
    end

    private
    def generate_classlist
      state = File.open("/var/tmp/chefnode.txt", "w")

      run_status.node.run_state[:seen_recipes].keys.each do |recipe|
        # Normalise name of default recipes
        name = recipe.match('::') ? recipe : "#{recipe}::default"
        state.puts("recipe.#{name}")
      end
      run_status.node.run_list.roles.each do |role|
        state.puts("role.#{role}")
      end

      state.close
    end
    
    private
    def generate_facts
      result = { "chef_environment" => run_status.node.chef_environment }

      # Add Ohai facts from the whitelist
      facts = run_status.node.automatic_attrs
      whitelist = run_status.node['mcollective']['fact_whitelist']
      whitelist.each do |k|
        ohai_flatten(k, facts[k], [], result)
      end
      # Note Ohai facts we skipped
      blocked = facts.keys - whitelist
      blocked.each do |f|
        result["blocked.#{f}"] = true
      end

      # Write out the facts
      factfile = File.open("/etc/mcollective/facts.yaml", "w")
      factfile.write(YAML.dump(result))
      factfile.close
    end
    
    # From https://raw.github.com/puppetlabs/mcollective-plugins/master/facts/ohai/opscodeohai_facts.rb
    private
    # Flattens the Ohai structure into something like:
    #
    #  "languages.java.version"=>"1.6.0"
    def ohai_flatten(key, val, keys, result)
      keys << key
      if val.is_a?(Mash)
        val.each_pair do |nkey, nval|
          ohai_flatten(nkey, nval, keys, result)

          keys.delete_at(keys.size - 1)
        end
      else
        key = keys.join(".")
        if val.is_a?(Array)
          result[key] = val.join(", ")
        else
          result[key] = val
        end
      end
    end

  end
end

