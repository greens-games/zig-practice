const std = @import("std");
const json = std.json;

pub const HTTPHeader = struct {
    name: []const u8,
    value: []const u8,

    pub fn to_string(self: *const HTTPHeader) ![]const u8 {
        const allocator = std.heap.page_allocator;
        var list = std.ArrayList(u8).init(allocator);
        try list.appendSlice(self.name);
        try list.append(':');
        try list.appendSlice(self.value);
        return list.items;
    }
};

test "Test HTTPHeader" {
    const header = HTTPHeader{
        .name = "Content-Type",
        .value = "application/json",
    };

    const expected = "Content-Type:application/json";
    const actual = try header.to_string();
    try std.testing.expect(std.mem.eql(u8, actual, expected));
}

test "Test Splitting" {
    const input = "Content-Type:application/json";
    const expected = HTTPHeader{
        .name = "Content-Type",
        .value = "application/json",
    };

    var val = std.mem.split(u8, input, ":");
    const actual = HTTPHeader{
        .name = val.next() orelse "",
        .value = val.next() orelse "",
    };

    try std.testing.expect(std.mem.eql(u8, actual.name, expected.name));
}

const Person = struct {
    name: []const u8,
    age: u32,
    city: []const u8,
};

test "Testing JSON" {
    const json_str =
        \\{
        \\    "name": "John Doe",
        \\    "age": 30,
        \\    "city": "New York"
        \\}
    ;

    const allocator = std.testing.allocator;
    const json_data = try json.parseFromSlice(Person, allocator, json_str, .{});
    defer json_data.deinit();
    try std.testing.expect(std.mem.eql(u8, json_data.value.name, "John Doe"));
}
