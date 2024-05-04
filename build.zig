const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const strip = b.option(bool, "strip", "Omit debug information");

    const name = "tidy";
    const upstream = b.dependency(name, .{});

    const lib = b.addStaticLibrary(.{
        .name = name,
        .target = target,
        .optimize = optimize,
        .strip = strip,
    });
    lib.root_module.addIncludePath(upstream.path("include"));
    lib.root_module.addCSourceFiles(.{
        .root = upstream.path("src"),
        .files = &.{
            "access.c",
            "attrs.c",
            "istack.c",
            "parser.c",
            "tags.c",
            "entities.c",
            "lexer.c",
            "pprint.c",
            "charsets.c",
            "clean.c",
            "message.c",
            "config.c",
            "alloc.c",
            "attrdict.c",
            "buffio.c",
            "fileio.c",
            "streamio.c",
            "tagask.c",
            "tmbstr.c",
            "utf8.c",
            "tidylib.c",
            "mappedio.c",
            "gdoc.c",
            "language.c",
            "messageobj.c",
            "sprtf.c",
        },
    });
    lib.installHeadersDirectory(upstream.path("include"), "", .{ .include_extensions = &.{
        "tidy.h",
        "tidybuffio.h",
        "tidyenum.h",
        "tidyplatform.h",
    } });
    lib.linkLibC();

    const exe = b.addExecutable(.{
        .name = name,
        .target = target,
        .optimize = optimize,
        .strip = strip,
    });
    exe.root_module.addIncludePath(upstream.path("src"));
    exe.root_module.addCSourceFiles(.{
        .root = upstream.path("console"),
        .files = &.{"tidy.c"},
    });
    exe.root_module.linkLibrary(lib);
    b.installArtifact(exe);
}
