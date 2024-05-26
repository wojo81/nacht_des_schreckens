class zmd_Switching : EventHandler {
    static ui bool isKeyForCommand(int key, string command) {
        Array<int> keys;
        bindings.getAllKeysForCommand(keys, command);
        return keys.find(key) != keys.size();
    }

    override bool inputProcess(InputEvent event) {
        if (event.type != InputEvent.Type_KeyDown)
            return false;

        let key = event.keyScan;
        for (let i = 0; i <= 11; ++i) {
            if (isKeyForCommand(key, 'slot '..i)) {
                EventHandler.sendNetworkEvent('switchWeapon', i);
                return true;
            }
        }
        if (isKeyForCommand(key, 'weapNext')) {
            EventHandler.sendNetworkEvent('switchWeapon', 0);
            return true;
        } else if (isKeyForCommand(key, 'weapPrev')) {
            EventHandler.sendNetworkEvent('switchWeapon', -1);
            return true;
        }
        return false;
    }

    override void networkProcess(ConsoleEvent e) {
        if (e.name == 'switchWeapon') {
            let manager = zmd_InventoryManager.fetchFrom(players[e.player].mo);
            if (manager != null && manager.switchWeapon) {
                switch (e.args[0]) {
                case 0:
                    manager.nextWeapon();
                    break;
                case -1:
                    manager.previousWeapon();
                    break;
                default:
                    manager.selectWeapon(e.args[0] - 1);
                }
            }
        }
    }
}