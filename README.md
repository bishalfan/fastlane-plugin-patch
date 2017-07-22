# patch plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-patch)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-patch`, add it to your project by running:

```bash
fastlane add_plugin patch
```

## About patch

Apply and revert pattern-based patches to any text file.

### apply_patch action

```Ruby
apply_patch files: "examples/PatchTestAndroid/app/src/main/AndroidManifest.xml",
            regexp: %r{^\s*</application>},
            mode: :prepend,
            text: "        <meta-data android:name=\"foo\" android:value=\"bar\" />\n"
```

This action matches one or all occurrences of a specified regular expression and
modifies the file contents based on the optional `:mode` parameter. By default,
the action appends the specified text to the pattern match. It can also prepend
the text or replace the pattern match with the text. Use an optional `:global`
parameter to apply the patch to all instances of the regular expression.

The `regexp`, `text`, `mode` and `global` options may be specified in a YAML file to
define a patch, e.g.:

**patch.yaml**:
```yaml
regexp: '^\s*</application>'
mode: 'prepend'
text: "        <meta-data android:name='foo' android:value='bar' />\n"
global: false
```

**Fastfile**:
```Ruby
apply_patch files: "examples/PatchTestAndroid/app/src/main/AndroidManifest.xml",
            patch: "patch.yaml"
```

### revert_patch action

Revert patches by passing the same arguments to the `revert_patch` action:

```Ruby
revert_patch files: "examples/PatchTestAndroid/app/src/main/AndroidManifest.xml",
             regexp: %r{^\s*</application>},
             mode: :prepend,
             text: "        <meta-data android:name=\"foo\" android:value=\"bar\" />\n"
```

```Ruby
revert_patch files: "examples/PatchTestAndroid/app/src/main/AndroidManifest.xml",
             patch: "patch.yaml"
```

Patches using the `:replace` mode cannot be reverted.

### Options

|key|description|type|optional|default value|
|---|-----------|----|--------|-------------|
|:files|Absolute or relative path(s) to one or more files to patch|Array or String|no| |
|:regexp|A regular expression to match|Regexp|yes| |
|:text|Text to append to the match|String|yes| |
|:global|If true, patch all occurrences of the pattern|Boolean|yes|false|
|:mode|:append, :prepend or :replace|Symbol|yes|:append|
|:offset|Offset from which to start matching|Integer|yes|0|
|:patch|A YAML file specifying patch data|String|yes| |

The :regexp and :text options must be set either in a patch file specified using the
:patch argument or via arguments in the Fastfile.

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, and running `fastlane install_plugins`.

The examples folder contains an empty Android project called PatchTestAndroid. There is an example
patch at the repo root in `patch.yaml` that will add a `meta-data` key to the end of the `application`
element in the Android project's manifest. The Fastfile includes two lanes: `apply` and `revert`.

Apply the patch to `examples/PatchTestAndroid/app/src/main/AndroidManifest.xml`:
```bash
fastlane apply
```

Revert the patch:
```bash
fastlane revert
```

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
