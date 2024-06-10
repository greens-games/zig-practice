const std = @import("std");
const json = std.json;
const mem = std.mem;

pub const HTTPHeader = struct {
    name: []const u8,
    value: []const u8,
};

pub const Request = struct {
    method: []const u8,
    path: []const u8,
    headers: []HTTPHeader,
    body: []const u8,
};

pub const Response = struct {
    status_code: u32,
    headers: []HTTPHeader,
    body: []const u8,
};

pub const Endpoint = struct {
    path: []const u8,
    get: *const fn (req: Request) Response = undefined,
    post: *const fn (req: Request) Response = undefined,
};

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

//Unexpected results
test "Testing stringify JSON" {
    const person = Person{
        .name = "John Doe",
        .age = 30,
        .city = "New York",
    };

    const allocator = std.testing.allocator;
    var buf = try std.ArrayList(u8).initCapacity(allocator, 1024);
    defer buf.deinit();

    try json.stringify(person, .{}, buf.writer());

    const expected = "{\"name\":\"John Doe\",\"age\":30,\"city\":\"New York\"}";

    try std.testing.expect(std.mem.eql(u8, buf.items, expected));
}
