require 'yaml'

module Fastlane
  module Actions
    class RevertPatchAction < Action
      def self.run(params)
        if params[:patch]
          # raises
          patch = YAML.load_file params[:patch]

          # If the :patch option is present, load these params from the
          # specified file. Action args override.
          %w{regexp text mode global}.each do |option|
            value = patch[option]
            next if value.nil?

            case option.to_sym
            when :regexp
              params[:regexp] = /#{value}/
            when :mode
              params[:mode] = value.to_sym
            else
              params[option.to_sym] = value
            end
          end
        end

        UI.user_error! "Must specify :regexp and :text either in a patch or via arguments" if
          params[:regexp].nil? || params[:text].nil?

        helper = Fastlane::Helper::PatchHelper
        modified_contents = File.open(params[:file], "r") do |f|
          contents = f.read
          helper.revert_patch contents,
                             params[:regexp],
                             params[:text],
                             params[:global],
                             params[:mode],
                             params[:offset]
        end

        File.open(params[:file], "w") { |f| f.write modified_contents }
      rescue => e
        UI.user_error! "Error in RevertPatchAction: #{e.message}\n#{e.backtrace}"
      end

      def self.description
        "Apply and revert pattern-based patches to any text file."
      end

      def self.authors
        ["Jimmy Dee"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "More to come"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :file,
                               description: "Absolute or relative path to a file to patch",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :regexp,
                               description: "A regular expression to match",
                                  optional: true,
                                      type: Regexp),
          FastlaneCore::ConfigItem.new(key: :text,
                               description: "Text to append to the match",
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :global,
                               description: "If true, patch all occurrences of the pattern",
                                  optional: true,
                             default_value: false,
                                 is_string: false),
          FastlaneCore::ConfigItem.new(key: :offset,
                               description: "Offset from which to start matching",
                                  optional: true,
                             default_value: 0,
                                      type: Integer),
          FastlaneCore::ConfigItem.new(key: :mode,
                               description: ":append or :prepend",
                                  optional: true,
                             default_value: :append,
                                      type: Symbol),
          FastlaneCore::ConfigItem.new(key: :patch,
                               description: "A YAML file specifying patch data",
                                  optional: true,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Platforms.md
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
