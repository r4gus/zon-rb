# Zig Object Notation (ZON) for Ruby

The [Zig](https://ziglang.org/) Object Notation (ZON) is a file format primarily used within the Zig ecosystem. For example, ZON is used for the Zig package [manifest](https://github.com/ziglang/zig/blob/b7ab62540963d80f68d0e9ee7ce18520fb173487/doc/build.zig.zon.md).

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
```

## Usage

To parse ZON data into a Ruby object, one can use the `Zon::parse` method. The method expects either a `String` or `IO` (`File`) object as its argument.

```irb
irb(main):001> Zon::parse(".{ \"foo\", \"bar\"}")
=> ["foo", "bar"]
irb(main):002> Zon.parse(File.open("../PassKeeZ/build.zig.zon"))
=>
{name: :passkeez,
 version: "0.5.3",
 minimum_zig_version: "0.15.1",
 fingerprint: 15931082159778014966,
 dependencies:
  {keylib:
    {url: "https://github.com/Zig-Sec/keylib/archive/refs/tags/0.7.0.tar.gz",
     hash: "keylib-0.7.0-mbYjk6qaCQACutrMpyhgstSmYxSKmcuRmLI-CJSumBeA"},
   uuid:
    {url: "https://github.com/r4gus/uuid-zig/archive/refs/tags/0.4.0.tar.gz",
     hash: "uuid-0.4.0-oOieIR2AAAChAUVBY4ABjYI1XN0EbVALmiN0JIlggC3i"},
   kdbx: {path: "../kdbx"}},
 paths: ["build.zig", "build.zig.zon", "linux", "README.md", "script", "src", "static"]}
```

To serialize a Ruby object into ZON, use the `Zon::serialize` method. 

```irb
irb(main):002> o
=>
{name: :passkeez,
 version: "0.5.3",
 minimum_zig_version: "0.15.1",
 fingerprint: 15931082159778014966,
 dependencies:
  {keylib: {url: "https://github.com/Zig-Sec/keylib/archive/refs/tags/0.7.0.tar.gz", hash: "keylib-0.7.0-mbYjk6qaCQACutrMpyhgstSmYxSKmcuRmLI-CJSumBeA"},
   uuid: {url: "https://github.com/r4gus/uuid-zig/archive/refs/tags/0.4.0.tar.gz", hash: "uuid-0.4.0-oOieIR2AAAChAUVBY4ABjYI1XN0EbVALmiN0JIlggC3i"},
   kdbx: {path: "../kdbx"}},
 paths: ["build.zig", "build.zig.zon", "linux", "README.md", "script", "src", "static"]}
irb(main):013> puts(Zon::serialize(o, {:indent_level => 4}))
.{
    .name = .passkeez,
    .version = "0.5.3",
    .minimum_zig_version = "0.15.1",
    .fingerprint = 0xdd1692d15d21a6f6,
    .dependencies = .{
        .keylib = .{
            .url = "https://github.com/Zig-Sec/keylib/archive/refs/tags/0.7.0.tar.gz",
            .hash = "keylib-0.7.0-mbYjk6qaCQACutrMpyhgstSmYxSKmcuRmLI-CJSumBeA",
        },
        .uuid = .{
            .url = "https://github.com/r4gus/uuid-zig/archive/refs/tags/0.4.0.tar.gz",
            .hash = "uuid-0.4.0-oOieIR2AAAChAUVBY4ABjYI1XN0EbVALmiN0JIlggC3i",
        },
        .kdbx = .{
            .path = "../kdbx",
        },
    },
    .paths = .{
        "build.zig",
        "build.zig.zon",
        "linux",
        "README.md",
        "script",
        "src",
        "static",
    },
}
```

To customize the generated ZON data one can use the `:indent_level` and `:ibase` options. The `:indent_level` specifies how much each block is indented. The `:ibase` option can be used to define in which format (hex: 16, octal: 8, binary: 2, decimal: 10) an `Integer` should be serialized. The default for `:ibase` is `16` (hexadecimal).

```irb
irb(main):010> Zon::serialize(255, {:ibase => 2})
=> "0b11111111"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/r4gus/zon-rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
