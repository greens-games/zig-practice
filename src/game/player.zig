const std = @import("std");

pub const Class = enum { WARRIOR, MAGE, RANGER };

pub const PlayerCharacter = struct { class_name: []const u8, class_health: i16 = 0 };

pub fn generateClass(class: Class) PlayerCharacter {
    switch (class) {
        Class.WARRIOR => {
            return .{ .class_name = "Warrior", .class_health = 15 };
        },
        Class.MAGE => return .{ .class_name = "Mage", .class_health = 5 },
        Class.RANGER => return .{ .class_name = "Ranger", .class_health = 7 },
    }
}

test "choose warrior" {
    const p = generateClass(Class.WARRIOR);

    try std.testing.expect(p.class_health == 15);
}
