require "pattern_patch"

module Fastlane
  module Actions
    class ApplyPatchAction < Action
      def self.run(params)
        if params[:patch]
          patch = PatternPatch::Patch.from_yaml params[:patch]
        else
          patch = PatternPatch::Patch.new params
        end

        patch.apply params[:files], offset: params[:offset]
      rescue => e
        UI.user_error! "Error in ApplyPatchAction: #{e.message}\n#{e.backtrace}"
      end

      def self.description
        "Apply pattern-based patches to any text file."
      end

      def self.authors
        ["Jimmy Dee"]
      end

      def self.details
        <<-EOF
Append or prepend text to a specified pattern in a list of files or
replace it, once or globally. Patches are specified by arguments or
YAML files. Revert the same patches with the revert_patch action.
        EOF
      end

      def self.example_code
        [
          <<-EOF
            apply_patch(
              files: "examples/PatchTestAndroid/app/src/main/AndroidManifest.xml",
              regexp: %r{^\s*</application>},
              mode: :prepend,
              text: "        <meta-data android:name=\"foo\" android:value=\"bar\" />\n"
            )
          EOF,
          <<-EOF
            apply_patch(
              files: "examples/PatchTestAndroid/app/src/main/AndroidManifest.xml",
              patch: "patch.yaml"
            )
          EOF
        ]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :files,
                               description: "Absolute or relative path(s) to one or more files to patch",
                                  optional: false,
                                 is_string: false),
          FastlaneCore::ConfigItem.new(key: :regexp,
                               description: "A regular expression to match",
                                  optional: true,
                                      type: Regexp),
          FastlaneCore::ConfigItem.new(key: :text,
                               description: "Text used to modify to the match",
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
                               description: ":append, :prepend or :replace",
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
        true
      end

      def self.deprecated_notes
        <<-EOF
Please use the patch action instead.
        EOF
      end

      def self.category
        :deprecated
      end
    end
  end
end
