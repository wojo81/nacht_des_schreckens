class zmd_MysteryBoxSelection : EventHandler {
    Array<String> names;
    Array<String> sprites;

    void add(String weaponClass, String weaponSprite) {
        self.names.push(weaponClass);
        self.sprites.push(weaponSprite);
    }

    int randomIndex() {
        return random[randomItem](0, self.names.size() - 1);
    }

    String pickSprite() {
        return self.sprites[self.randomIndex()];
    }

    String, String pick(zmd_Player player) {
        let index = self.randomIndex();
        while (player.countInv(self.names[index]))
            index = self.randomIndex();
        return self.names[index], self.sprites[index];
    }

    override void worldLoaded(WorldEvent e) {
        self.add('Raygun', 'rayp');
        self.add('M1garand', 'm1ga');
        self.add('DoubleBarrelShotgun', 'dbla');
//         self.add('Ppsh', 'ppsp');
    }
}

class zmd_MysteryBoxHandler : EventHandler {
    Array<zmd_MysteryBoxLocation> locations;
    int activeIndex;
    int moveCount;

    void moveActiveBox() {
        ++self.moveCount;
        if (self.moveCount == 1)
            zmd_PowerupHandler(EventHandler.find('zmd_PowerupHandler')).availablePowerups.push('zmd_FireSaleDrop');
        self.removeBox(self.activeIndex);
        self.spawnBox(self.activeIndex = self.randomIndex(self.activeIndex), true);
    }

    void removeBox(int index) {
        self.locations[index].removeBox();
    }

    void spawnBox(int index, bool canMove) {
        self.locations[index].spawnBox(canMove);
    }

    int randomIndex(int hole) {
        let index = random[randomLocation](0, locations.size() - 1);
        while (index == hole)
            index = random[randomLocation](0, locations.size() - 1);
        return index;
    }

    void spawnAllBoxes() {
        for (int i = 0; i != locations.size(); ++i) {
            if (i != activeIndex)
                self.spawnBox(i, false);
            else
                locations[i].box.canMove = false;
        }
    }

    void removeAllBoxes() {
        for (int i = 0; i != locations.size(); ++i) {
            if (i != activeIndex)
                locations[i].removeBox();
            else
                locations[i].box.canMove = true;
        }
    }

    override void worldLoaded(WorldEvent e) {
        Array<zmd_MysteryBoxLocation> excludedLocations;

        self.activeIndex = -1;
        int index = 0;

        let actorIterator = Level.createActorIterator(1);
        zmd_MysteryBoxLocation location;

        while (location = zmd_MysteryBoxLocation(actorIterator.next())) {
            if (location.args[0] < 0) {
                excludedLocations.push(location);
            } else if (location.args[0] > 0) {
                self.activeIndex = index;
                self.locations.push(location);
            } else {
                self.locations.push(location);
            }
            ++index;
        }

        if (self.activeIndex == -1)
            self.activeIndex = self.randomIndex(self.activeIndex);

        foreach (location : excludedLocations)
            self.locations.push(location);

        self.spawnBox(self.activeIndex, locations.size() > 1);
    }
}

class zmd_SpinItem : Actor {
    zmd_MysteryBoxSelection selection;

    zmd_Player receiver;
    bool ready;

    String itemName;
    String spriteName;
    int cycleCount;
    bool isBoxMoving;

    Default {
        +noGravity
        +wallSprite
    }

    action State cycle() {
        if (invoker.cycleCount == 15) {
            if (invoker.isBoxMoving) {
                invoker.spriteName = 'ikic';
                return resolveState('MoveBox');
            }
            [invoker.itemName, invoker.spriteName] = invoker.selection.pick(invoker.receiver);
            return resolveState('View');
        } else {
            invoker.spriteName = invoker.selection.pickSprite();
            ++invoker.cycleCount;
            return resolveState(null);
        }
    }

    action void display() {
        invoker.sprite = getSpriteIndex(invoker.spriteName);
    }

    action void enablePickup() {
        invoker.ready = true;
    }

    override void beginPlay() {
        super.beginPlay();
        self.selection = zmd_MysteryBoxSelection(EventHandler.find('zmd_MysteryBoxSelection'));
    }

    States {
    Spawn:
        tnt1 a 25;
    Spin:
        #### a 0 cycle;
        #### a 8 bright display;
        loop;
    View:
        #### a 0 enablePickup;
        #### a 250 bright display;
        stop;
    MoveBox:
        #### a 350 bright display;
        stop;
    }
}

class zmd_MysteryBox : zmd_Interactable {
    zmd_SpinItem spinItem;

    const cost = 950;
    const discountCost = 10;

    bool canMove;
    int spinCount;

    Default {
        radius 30;
        height 30;

        +wallSprite
        +solid;
    }

    void open(zmd_Player receiver) {
        ++self.spinCount;
        let offset = Actor.angleToVector(self.angle, 6);
        self.spinItem = zmd_SpinItem(Actor.spawn('zmd_SpinItem', self.pos + (offset.x, offset.y, 15)));
        self.spinItem.angle = self.angle;
        self.spinItem.receiver = receiver;
        self.spinItem.isBoxMoving = self.shouldMove();
        if (self.spinItem.isBoxMoving)
            self.setStateLabel('Move');
        else
            self.setStateLabel('Spin');
    }

    action void close() {
        invoker.spinItem.destroy();
        invoker.spinItem = null;
        invoker.setStateLabel('Idle');
    }

    action void finishMoving() {
        invoker.spinItem.receiver.giveInventory('zmd_Points', zmd_MysteryBox.cost);
        zmd_MysteryBoxHandler(EventHandler.find('zmd_MysteryBoxHandler')).moveActiveBox();
    }

    bool shouldMove() {
        return self.canMove && self.spinCount > 4 && random[boxSwitching](1, 3) == 1;
    }

    override void doTouch(zmd_Player player) {
        if (self.spinItem == null) {
            if (player.countInv('zmd_FireSale'))
                player.hintHud.setMessage(zmd_Interactable.costOf(discountCost));
            else
                player.hintHud.setMessage(zmd_Interactable.costOf(cost));
        }
        else if (self.spinItem.ready && self.spinItem.receiver == player)
            player.hintHud.setMessage("[Pick Up]");
    }

    override bool doUse(zmd_Player player) {
        if (self.spinItem == null) {
            if ((player.countInv('zmd_FireSale') && player.maybePurchase(discountCost)) || player.maybePurchase(cost)) {
                self.open(player);
                return true;
            }
        } else if (spinItem.ready && spinItem.receiver == player) {
            player.a_giveInventory(spinItem.itemName);
            self.close();
            return true;
        }
        return false;
    }

    States {
    Idle:
        tnt1 a 0 {active = false;}
        msty b 70 bright;
        tnt1 a 0 {active = true;}
    Spawn:
        msty a 1 bright;
        loop;
    Spin:
        tnt1 a 0 a_startSound("game/mystery", volume: 0.5);
        msty b 350 bright;
        tnt1 a 0 close;
    Move:
        tnt1 a 0 a_startSound("game/mystery", volume: 0.5);
        msty b 250 bright;
        tnt1 a 0 finishMoving;
        stop;
    }
}

class zmd_MysteryBoxLocation : Actor {
    zmd_MysteryBox box;

    void spawnBox(bool canMove) {
        self.box = zmd_MysteryBox(Actor.spawn('zmd_MysteryBox', self.pos));
        self.box.angle = self.angle;
        self.box.canMove = canMove;
    }

    void removeBox() {
        if (self.box.spinItem != null)
            self.box.spinItem.destroy();
        self.box.destroy();
    }
}
