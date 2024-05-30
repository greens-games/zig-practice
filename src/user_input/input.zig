const std = @import("std");
const io = std.io;
const fs = std.fs;
const player = @import("../game/player.zig");
//NOTE:
//readUntilDelimeterOrEof returns a conditional []u8 (ascii chars or ints)
//this needs to be handle with orelse, loops, or if()
//YOu can then use a closure to capture the returned val and use in you scope

//this is a way to capture user input and print it out
pub fn get_user_input() !void {
    const reader = io.getStdIn().reader();
    var buff_reader = io.bufferedReader(reader);
    var buf: [1024]u8 = undefined;
    var buf_reader = buff_reader.reader();
    while (try buf_reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        std.debug.print("you entered: {s}\n", .{line});
    }
}

//THis will read in a file
pub fn read_in_file() !void {
    const f = try fs.openFileAbsolute("/home/oem/dev/zig-practice/src/something.yaml", .{});
    const reader = f.reader();
    var b_reader = io.bufferedReader(reader);
    var buf: [1024]u8 = undefined;
    var buf_reader = b_reader.reader();
    while (try buf_reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        std.debug.print("you entered: {s}\n", .{line});
    }
}

pub fn user_input_with_prompt() !void {
    try getPlayerClass();
}

fn getPlayerClass() !void {
    const reader = io.getStdIn().reader();
    var buff_reader = io.bufferedReader(reader);
    var buf: [1024]u8 = undefined;
    var buf_reader = buff_reader.reader();
    std.debug.print("Choose you class: \n WARRIOR: 1\n MAGE: 2,\n RANGER: 3\n", .{});

    const allocator = std.heap.page_allocator;

    if (try buf_reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const choice: u8 = @intCast(line[0]);
        const empty = "";
        var player_char: player.PlayerCharacter = .{ .class_name = empty };
        const mem = try allocator.alloc(player.PlayerCharacter, @sizeOf(player.PlayerCharacter));
        defer allocator.free(mem);
        const choice_offset = 49;
        switch (choice - choice_offset) {
            0 => player_char = player.generateClass(player.Class.WARRIOR),
            1 => player_char = player.generateClass(player.Class.MAGE),
            2 => player_char = player.generateClass(player.Class.RANGER),
            else => player_char = .{ .class_name = empty },
        }
        std.debug.print("Your class is: {s}, with health: {d}\n", .{ player_char.class_name, player_char.class_health });
    }
}
