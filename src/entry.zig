const std = @import("std");
const net = std.net;
const posix = std.posix;
const thread = std.Thread;

//NOTE:
//Both the start_server and start_posix_server fail with socket nto connected when reading
//doesn't matter if we use posix or net we get the same issue

pub fn start_server() !void {
    std.debug.print("starting server\n", .{});

    const s = try posix.socket(std.posix.AF.INET, posix.SOCK.STREAM, 0); //Create the IPv4 socket as a stream socket (Used for TCP) (UDP would use DGRAM)
    const a = try net.Address.resolveIp("127.0.0.1", 7001); //get the IPv4 address for localhost:7001
    const stream: net.Stream = .{ .handle = s };
    var server: net.Server = .{ .listen_address = a, .stream = stream };
    server = try server.listen_address.listen(.{});

    const conn: net.Server.Connection = try server.accept();
    while (true) {
        var buf: [1024]u8 = undefined;
        const num_read: usize = try conn.stream.read(&buf);
        std.debug.print("waiting for message\n", .{});
        std.debug.print("received: {s}\n", .{buf[0..]});
        _ = num_read;
        std.time.sleep(5000000000);
    }
}

pub fn start_posix_server() !void {
    var a = try net.Address.resolveIp("127.0.0.1", 8080); //get the IPv4 address for localhost:7001
    var sock_len = net.Address.getOsSockLen(a); //get the length of the socket defined by the OS

    const s = try posix.socket(std.posix.AF.INET, posix.SOCK.STREAM, 0); //Create the IPv4 socket as a stream socket (Used for TCP) (UDP would use DGRAM)
    defer posix.close(s);
    try posix.bind(s, &a.any, sock_len); //bind the socket to the address localhost:7001
    //This is not required for UDP
    try posix.listen(s, 1024); //tell the socket to start listening
    std.debug.print("accepting connections: \n", .{});
    const client_sock = try posix.accept(s, &a.any, &sock_len, 0); //tell the socket at given address to start accepting connections
    while (true) {
        //clear the buffer every loop
        //we will probably want to spin up a thread to handle the connection for each client
        //this is just a simple example
        var buf: [1024]u8 = undefined;
        const num_read: usize = try posix.recv(client_sock, &buf, 0); // receive a message from the socket
        std.debug.print("received: {s}\n", .{buf[0..]});
        _ = try posix.write(client_sock, buf[0..num_read]);
    }
}

test "always fail" {
    try std.testing.expect(false);
}
