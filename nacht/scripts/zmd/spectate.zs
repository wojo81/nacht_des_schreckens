class zmd_Spectate : Inventory {
    static void setOrigin(Actor player, Vector3 newPos) {
        LinkContext ctx;

        player.unlinkFromWorld(ctx);
        player.setXYZ(newPos);
        player.linkToWorld(ctx);
        player.findFloorCeiling (ffcf_onlySpawnPos);
    }

    override void attachToOwner(Actor other) {
        super.attachToOwner(other);
        zmd_InventoryManager(other.findInventory('zmd_InventoryManager')).spectating = true;
        self.setOrigin(self.owner, (-2150, 2500, 0));
        self.owner.setCamera(self.choosePlayer());
    }

    override void detachFromOwner() {
        let manager = zmd_InventoryManager(owner.findInventory('zmd_InventoryManager'));
        if (!manager.gameOver) {
            manager.spectating = false;
            self.setOrigin(self.owner, (0, 0, 0));
            self.owner.setCamera(self.owner);
        }
        super.detachFromOwner();
    }

    Actor choosePlayer() {
        foreach (player : players)
            if (player.mo != null && player.mo.playerNumber() != self.owner.playerNumber())
                return player.mo;
        return null;
    }
}

class zmd_GameOverSpectate : Inventory {
    override void attachToOwner(Actor other) {
        super.attachToOwner(other);
        zmd_InventoryManager(other.findInventory('zmd_InventoryManager')).gameOver = true;
        // self.owner.die(self.owner, self.owner);
        zmd_Spectate.setOrigin(self.owner, (-2150, 2500, 0));
        self.owner.setCamera(Level.createActorIterator(11).next());
        thing_activate(11);
    }
}