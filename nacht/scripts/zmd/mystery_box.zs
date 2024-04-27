class zmd_MysteryBox : zmd_Interactable {
    const regularCost = 950;
    const discountCost = 10;

    zmd_MysteryBoxHandler handler;
    zmd_MysteryBoxPool pool;
    bool shouldFade;
    bool canMove;
    int spinCount;

    Default {
        radius 50;
        height 200;

        +wallSprite
        +solid;
    }

    static zmd_MysteryBox spawnIn(zmd_MysteryBoxLocation location, bool canMove) {
        let self = zmd_MysteryBox(Actor.spawn('zmd_MysteryBox', location.pos, allow_replace));
        self.handler = zmd_MysteryBoxHandler.fetch();
        self.angle = location.angle;
        self.canMove = canMove;
        return self;
    }

    override void beginPlay() {
        self.changeTid(1);
        self.pool = zmd_MysteryBoxPool.fetch();
    }

    override void doTouch(PlayerPawn player) {
        if (player.countInv('zmd_FireSalePower') != 0)
            zmd_HintHud(player.findInventory('zmd_HintHud')).setMessage(self.costOf(self.discountCost));
        else
            zmd_HintHud(player.findInventory('zmd_HintHud')).setMessage(self.costOf(self.regularCost));
    }

    override bool doUse(PlayerPawn player) {
        if ((player.countInv('zmd_FireSalePower') != 0 && zmd_Points.takeFrom(player, self.discountCost)) || zmd_Points.takeFrom(player, self.regularCost)) {
            self.open(player);
            return true;
        }
        return false;
    }

    Vector3 getOffset() {
        let offset = Actor.angleToVector(self.angle, 6);
        return self.pos + (offset.x, offset.y, 15);
    }

    bool shouldMove() {
        // return self.canMove && self.spinCount == 2;
        return self.canMove && self.spinCount > 4 && random[boxSwitching](1, 3) == 1;
    }

    State whenShouldFade(StateLabel label) {
        if (self.shouldFade)
            return resolveState(label);
        return resolveState(null);
    }

    void open(PlayerPawn receiver) {
        ++self.spinCount;
        self.bspecial = false;
        zmd_MysteryBoxSpin.spawnIn(self, receiver);
        self.setStateLabel('Open');
    }

    void close() {
        self.setStateLabel('Close');
    }

    void finishClosing() {
        self.bspecial = true;
    }

    void fade() {
        self.shouldFade = true;
        if (self.bspecial) {
            self.setStateLabel('Fade');
            self.bspecial = false;
        }
    }

    States {
    Close:
        msty b 20;
        tnt1 a 0 whenShouldFade('Fade');
        tnt1 a 0 finishClosing;
    Spawn:
    Idle:
        msty a -1;
        loop;
    Open:
        tnt1 a 0 a_startSound("game/mystery", volume: 0.5);
    Open.Idle:
        msty b -1 bright;
        loop;
    Fade:
        msty a 20;
        stop;
    }
}

class zmd_MysteryBoxSpin : Actor {
    PlayerPawn receiver;
    zmd_MysteryBox box;

    Default {
       +noGravity
        +wallSprite
    }

    override void postBeginPlay() {
        if (self.receiver is 'zmd_Player')
            self.scale = (0.5, 0.5);
    }

    static zmd_MysteryBoxSpin spawnIn(zmd_MysteryBox box, PlayerPawn receiver) {
        let self = zmd_MysteryBoxSpin(Actor.spawn('zmd_MysteryBoxSpin', box.getOffset(), allow_replace));
        self.receiver = receiver;
        self.box = box;
        self.angle = box.angle;
        return self;
    }

    void spin() {
        self.sprite = self.box.pool.chooseSpriteFor(self.receiver, self.sprite);
    }

    void finish() {
        if (self.box.shouldMove())
            zmd_MysteryBoxLock.spawnIn(self.box, self.receiver);
        else {
            let item = self.box.pool.choosePickupFor(self.receiver, self.sprite);
            zmd_MysteryBoxPickup.spawnIn(self.box, item, self.receiver);
        }
    }

    States {
    Spawn:
        #### aaaaaa 20 nodelay bright spin;
        #### a 0 finish;
        stop;
    }
}

class zmd_MysteryBoxLock : Actor {
    PlayerPawn receiver;
    zmd_MysteryBox box;

    Default {
        floatBobStrength 0.1;

        +noGravity
        +wallSprite
        +floatBob
    }

    static zmd_MysteryBoxLock spawnIn(zmd_MysteryBox box, PlayerPawn receiver) {
        let self = zmd_MysteryBoxLock(Actor.spawn('zmd_MysteryBoxLock', box.getOffset(), allow_replace));
        self.box = box;
        self.receiver = receiver;
        self.angle = box.angle;
        return self;
    }

    void moveBox() {
        self.box.handler.moveActiveBox();
        self.box.close();
        self.receiver.giveInventory('zmd_Points', self.box.regularCost);
        self.destroy();
    }

    States {
    Spawn:
        mink a 70 bright;
        tnt1 a 0 moveBox;
    }
}

class zmd_MysteryBoxPickup : zmd_Pickup {
    PlayerPawn receiver;
    zmd_MysteryBox box;

    Default {
        floatBobStrength 0.1;

        +noGravity
        +wallSprite
        +floatBob

        radius 50;
    }

    static zmd_MysteryBoxPickup spawnIn(zmd_MysteryBox box, class<Weapon> pickupClass, PlayerPawn receiver) {
        let self = zmd_MysteryBoxPickup(Actor.spawn('zmd_MysteryBoxPickup', box.getOffset(), allow_replace));
        self.pickupClass = pickupClass;
        self.sprite = getDefaultByType(pickupClass).spawnState.sprite;
        self.receiver = receiver;
        self.box = box;
        self.angle = box.angle;
        return self;
    }

    override void doTouch(PlayerPawn player) {
        if (player == self.receiver)
            super.doTouch(player);
    }

    override bool doUse(PlayerPawn player) {
        if (self.giveTo(player)) {
            self.closeBox();
            return true;
        }
        return false;
    }

    bool giveTo(PlayerPawn player) {
        if (player == self.receiver && zmd_InventoryManager.couldPickup(player, self.pickupClass)) {
            if (player is 'zmd_Player')
                player.a_giveInventory(self.pickupClass);
            else {
                player.a_giveInventory(self.pickupClass);

                let ammoType = getDefaultByType(self.pickupClass).ammoType1;
                if (ammoType != null) {
                    let halfAmmo = getDefaultByType(ammoType).maxAmount / 2;
                    player.giveInventory(ammoType, halfAmmo - player.countInv(ammoType));
                }
            }
            return true;
        }
        return false;
    }

    void closeBox() {
        self.box.close();
        self.destroy();
    }

    States {
    Spawn:
        #### a 350 bright;
        tnt1 a 0 closeBox;
    }
}

class zmd_MysteryBoxPool : EventHandler {
    Array<class<Weapon> >[4] items;
    Array<int>[4] sprites;

    static zmd_MysteryBoxPool fetch() {
        return zmd_MysteryBoxPool(EventHandler.find('zmd_MysteryBoxPool'));
    }

    void add(int playerIndex, class<Weapon> item) {
        self.items[playerIndex].push(item);
        self.sprites[playerIndex].push(getDefaultByType(item).spawnState.sprite);
    }

    int randomIndexFor(PlayerPawn player) {
        return random[randomItem](0, self.items[player.playerNumber()].size() - 1);
    }

    int chooseSpriteFor(PlayerPawn player, int lastSprite) {
        let index = self.randomIndexFor(player);
        let playerNumber = player.playerNumber();
        while (self.sprites[playerNumber][index] == lastSprite)
            index = self.randomIndexFor(player);
        return self.sprites[playerNumber][index];
    }

    class<Weapon> choosePickupFor(PlayerPawn player, int lastSprite) {
        let index = self.randomIndexFor(player);
        let playerNumber = player.playerNumber();
        while (self.sprites[playerNumber][index] == lastSprite || player.countInv(self.items[playerNumber][index]) != 0)
            index = self.randomIndexFor(player);
        return self.items[playerNumber][index];
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

        let actorIterator = Level.createActorIterator(zmd_MysteryBoxLocation.tid, 'zmd_MysteryBoxLocation');
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

        if (self.locations.size() != 0) {
            if (self.activeIndex == -1)
                self.activeIndex = self.randomIndexWithout(self.activeIndex);

            foreach (location : excludedLocations)
                self.locations.push(location);

            self.spawnBox(self.activeIndex, locations.size() > 1);
        }
    }
}

class zmd_MysteryBoxLocation : Actor {
    const tid = 1;
    zmd_MysteryBox box;

    override void beginPlay() {
        self.changeTid(zmd_MysteryBoxLocation.tid);
    }

    void spawnBox(bool canMove) {
        self.box = zmd_MysteryBox.spawnIn(self, canMove);
    }

    void removeBox() {
        self.box.fade();
    }
}