module Fastlane
  module Helper
    class PatchHelper
      class << self
        # Add the specified text after the specified pattern.
        # Returns a modified copy of the string.
        #
        # :contents: A string to modify, e.g. the contents of a file
        # :regexp: A regular expression specifying a pattern to be matched
        # :text: Text to be appended to the specified pattern
        # :global: Boolean flag. If true, patch all occurrences of the regex.
        # :mode: :append, :prepend or :replace to specify how to apply the patch
        # :offset: Starting position for matching
        def apply_patch(contents, regexp, text, global, mode, offset)
          search_position = offset
          while (matches = regexp.match(contents, search_position))
            patched_pattern =
              case mode
              when :append
                "#{matches[0]}#{text}"
              when :prepend
                "#{text}#{matches[0]}"
              when :replace
                text
              else
                raise ArgumentError, "Invalid mode argument. Specify :append, :prepend or :replace."
              end

            contents = "#{matches.pre_match}#{patched_pattern}#{matches.post_match}"
            search_position = matches.pre_match.length + patched_pattern.length
            break unless global
          end
          contents
        end

        # Reverts a patch. Use the same arguments that were supplied to apply_patch.
        # The mode argument can only be :append or :prepend. Patches using :replace
        # cannot be reverted.
        # Returns a modified copy of the string.
        #
        # :contents: A string to modify, e.g. the contents of a file
        # :regexp: A regular expression specifying a pattern to be matched
        # :text: Text to be appended to the specified pattern
        # :global: Boolean flag. If true, patch all occurrences of the regex.
        # :mode: :append or :prepend. :replace patches cannot be reverted automatically.
        # :offset: Starting position for matching
        def revert_patch(contents, regexp, text, global, mode, offset)
          search_position = offset
          regexp_string = regexp.to_s

          patched_regexp =
            case mode
            when :append
              suffix = ""
              if regexp_string.end_with? "^"
                suffix = "\n"
                regexp_string.sub!(/\$$/, "")
              end

              /#{regexp_string}#{Regexp.quote(text)}#{suffix}/m
            when :prepend
              prefix = ""
              if regexp_string.start_with? "^"
                prefix = "\n"
                regexp_string.sub!(/^\^/, "")
              end

              /#{prefix}#{Regexp.quote(text)}#{regexp_string}/m
            else
              raise ArgumentError, "Invalid mode argument. Specify :append or :prepend."
            end

          while (matches = patched_regexp.match(contents, search_position))
            reverted_text = matches[0].sub(text, '')
            contents = "#{matches.pre_match}#{reverted_text}#{matches.post_match}"
            search_position = matches.pre_match.length + reverted_text.length
            break unless global
          end

          contents
        end
      end
    end
  end
end
