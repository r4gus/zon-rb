# frozen_string_literal: true

RSpec.describe Zon do

  it "has a version number" do
    expect(Zon::VERSION).not_to be nil
  end

  it "loads a build.zig.zon and parses it into a Manifest object" do
    v = File.read(File.join(__dir__, "zon/fixtures", "passkeez.build.zig.zon"))

    zon = Zon::parse v
    manifest = Zon::Zig::Manifest.new zon

    expect(manifest.name).to eq(:passkeez)
    expect(manifest.version).to eq("0.5.3")
    expect(manifest.fingerprint).to eq(0xdd1692d15d21a6f6)
    expect(manifest.minimum_zig_version).to eq("0.15.1")
    expect(manifest.dependencies[:keylib]).to eq({:url => "https://github.com/Zig-Sec/keylib/archive/refs/tags/0.7.0.tar.gz", :hash => "keylib-0.7.0-mbYjk6qaCQACutrMpyhgstSmYxSKmcuRmLI-CJSumBeA"})
    expect(manifest.dependencies[:kdbx]).to eq({:path => "../kdbx"})
    expect(manifest.paths).to eq([
        "build.zig",
        "build.zig.zon",
        "linux",
        "README.md",
        "script",
        "src",
        "static",
    ])

  end

end
