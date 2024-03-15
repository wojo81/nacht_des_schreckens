class zmd_MysteryBoxPool : EventHandler {
    Array<String> items;
    Array<String> sprites;

    static zmd_MysteryBoxPool fetch() {
        return zmd_MysteryBoxPool(EventHandler.find('zmd_MysteryBoxPool'));
    }

    override void worldLoaded(WorldEvent e) {
        self.add('Raygun', 'rayp');
        self.add('M1garand', 'm1ga');
        self.add('DoubleBarrelShotgun', 'dbla');
//         self.add('Ppsh', 'ppsp');
    }

    void add(String item, String sprite) {
        self.items.push(item);
        self.sprites.push(sprite);
    }

    int randomIndex() {
        return random[randomItem](0, self.items.size() - 1);
    }

    String chooseSprite() {
        return self.sprites[self.randomIndex()];
    }

    String, String chooseFor(zmd_Player player) {
        let index = self.randomIndex();
        while (player.countInv(self.items[index]) != 0)
            index = self.randomIndex();
        return self.items[index], self.sprites[index];
    }
}

class zmd_MysteryBoxHandler : EventHandler {
    Array<zmd_MysteryBoxLocation> locations;
    int activeIndex;
    int moveCount;

    static zmd_MysteryBoxHandler fetch() {
        return zmd_MysteryBoxHandler(EventHandler.find('zmd_MysteryBoxHandler'));
    }

    void moveActiveBox() {
        if (++self.moveCount == 1)
            zmd_DropPool.fetch().add('zmd_FireSale');
        self.removeBox(self.activeIndex);
        self.spawnBox(self.activeIndex = self.randomIndexWithout(self.activeIndex), true);
    }

    void removeBox(int index) {
        self.locations[index].removeBox();
    }

    void spawnBox(int index, bool canMove) {
        self.locations[index].spawnBox(canMove);
    }

    int randomIndexWithout(int hole) {
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
            self.activeIndex = self.randomIndexWithout(self.activeIndex);

        foreach (location : excludedLocations)
            self.locations.push(location);

        self.spawnBox(self.activeIndex, locations.size() > 1);
    }
}

class zmd_SpinItem : Actor {
    zmd_MysteryBoxPool pool;

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

    static zmd_SpinItem create(zmd_MysteryBox box, zmd_Player receiver) {
        let self = zmd_SpinItem(Actor.spawn('zmd_SpinItem', zmd_SpinItem.offsetFrom(box), allow_replace));
        self.receiver = receiver;
        self.pool = zmd_MysteryBoxPool.fetch();
        self.isBoxMoving = box.shouldMove();
        self.angle = box.angle;
        return self;
    }

    static Vector3 offsetFrom(zmd_MysteryBox box) {
        let offset = Actor.angleToVector(box.angle, 6);
        return box.pos + (offset.x, offset.y, 15);
    }

    action State cycle() {
        if (invoker.cycleCount++ == 15) {
            if (invoker.isBoxMoving) {
                invoker.spriteName = 'ikic';
                return resolveState('MoveBox');
            }
            [invoker.itemName, invoker.spriteName] = invoker.pool.chooseFor(invoker.receiver);
            return resolveState('View');
        } else {
            invoker.spriteName = invoker.pool.chooseSprite();
            return resolveState(null);
        }
    }

    action void display() {
        invoker.sprite = Actor.getSpriteIndex(invoker.spriteName);
    }

    action void enablePickup() {
        invoker.ready = true;
    }

    States {
    Spawn:
        tnt1 a 25;
    Spin:
        tnt1 a 0 cycle;
        #### a 8 bright display;
        loop;
    View:
        tnt1 a 0 enablePickup;
        #### a 250 bright display;
        stop;
    MoveBox:
        #### a 350 bright display;
        stop;
    }
}

class zmd_MysteryBox : zmd_Interactable {
    const regularCost = 950;
    const discountCost = 10;

    zmd_SpinItem spinItem;

    bool canMove;
    int spinCount;

    Default {
        radius 50;
        height 200;

        +wallSprite
        +solid;
    }

    static zmd_MysteryBox create(zmd_MysteryBoxLocation location, bool canMove) {
        let self = zmd_MysteryBox(Actor.spawn('zmd_MysteryBox', location.pos, allow_replace));
        self.angle = location.angle;
        self.canMove = canMove;
        return self;
    }

    override void doTouch(zmd_Player player) {
        if (self.spinItem == null) {
            if (player.countInv('zmd_FireSale'))
                player.hintHud.setMessage(self.costOf(self.discountCost));
            else
                player.hintHud.setMessage(self.costOf(self.regularCost));
        }
        else if (self.spinItem.ready && self.spinItem.receiver == player)
            player.hintHud.setMessage("[Pick Up]");
    }

    override bool doUse(zmd_Player player) {
        if (self.spinItem == null) {
            if ((player.countInv('zmd_FireSalePowerup') && player.purchase(self.discountCost)) || player.purchase(self.regularCost)) {
                self.open(player);
                return true;
            }
        } else if (self.spinItem.ready && self.spinItem.receiver == player) {
            player.a_giveInventory(self.spinItem.itemName);
            self.close();
            return true;
        }
        return false;
    }

    bool shouldMove() {
        return self.canMove && self.spinCount > 4 && random[boxSwitching](1, 3) == 1;
    }

    void open(zmd_Player receiver) {
        ++self.spinCount;
        self.spinItem = zmd_SpinItem.create(self, receiver);

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
        invoker.spinItem.receiver.giveInventory('zmd_Points', zmd_MysteryBox.regularCost);
        zmd_MysteryBoxHandler.fetch().moveActiveBox();
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
        self.box = zmd_MysteryBox.create(self, canMove);
    }

    void removeBox() {
        if (self.box != null) {
            if (self.box.spinItem != null)
                self.box.spinItem.destroy();
            self.box.destroy();
        }
    }
}