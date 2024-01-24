class zmd_Points : Inventory {
    Default {
        Inventory.maxAmount 999999;
    }

    static void give(Actor player, int amount) {
        let givenPoints = amount << player.countInv("zmd_DoublePoints");
        player.giveInventory("zmd_Points", givenPoints);
        let player = zmd_Player(player);
        if (player)
            player.pointDeltas.push(givenPoints);
    }
}