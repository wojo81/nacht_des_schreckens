class zmd_Rounds : EventHandler {
    const maxHordeCount = 32;
    const introSound = "game/intro";
    const beginRoundSound = "game/round";
    const endRoundSound = "game/siren";

    int currentRound;
    int zombieHealth;
    int unspawnedZombies;
    int liveZombies;
    int zombiesLeft;
    int tickCount;
    bool isTransitioning;

    zmd_Spawning spawning;
    zmd_DropPool dropPool;
    zmd_WorryHandler worryHandler;
    zmd_GlobalSound globalSound;

    static zmd_Rounds fetch() {
        return zmd_Rounds(EventHandler.find('zmd_Rounds'));
    }

    override void worldLoaded(WorldEvent e) {
        self.dropPool = zmd_DropPool.fetch();
        self.spawning = zmd_Spawning.init(self);
        zmd_WorryHandler.bind_with(self);
        self.globalSound = zmd_GlobalSound.create();
        self.globalSound.start(self.introSound);
        self.nextRound();
    }

    override void worldThingDied(WorldEvent e) {
        if (e.thing && e.thing.bIsMonster) {
            self.zombieKilled();
            if (self.roundOver()) {
                self.globalSound.start(self.endRoundSound, pitch: 0.75);
                self.isTransitioning = true;
                zmd_RoundDelay.create(self);
            }
        }
    }

    // override void worldTick() {
    //     super.worldTick();
    //     console.printf("");
    //     console.printf("unspawned %d", self.unspawnedZombies);
    //     console.printf("live zombies %d", self.liveZombies);
    //     console.printf("zombies left %d", self.zombiesLeft);
    // }

    int calcZombiesHealth() {
        return 25 + 20 * (self.currentRound - 1);
    }

    int calcZombiesCount() {
        return 4 + 3 * (self.currentRound - 1);
    }

    void nextRound() {
        ++self.currentRound;
        self.zombieHealth = self.calcZombiesHealth();
        self.unspawnedZombies = self.calcZombiesCount();
        self.zombiesLeft = self.unspawnedZombies;
        self.isTransitioning = false;
        self.dropPool.handleRoundChange();

        if (self.currentRound != 1)
            self.globalSound.start(self.beginRoundSound);
    }

    void zombieKilled() {
        --self.liveZombies;
        --self.zombiesLeft;
    }

    bool roundOver() {
        return self.zombiesLeft == 0;
    }

    bool readyToSpawn() {
        return !self.isTransitioning && self.liveZombies != self.maxHordeCount && self.unspawnedZombies != 0;
    }

    void startWorrying() {
        self.worryHandler.activate();
    }
}

class zmd_RoundDelay : Thinker {
    const delay = 35 * 10;

    zmd_Rounds rounds;
    int ticksLeft;

    static zmd_RoundDelay create(zmd_Rounds rounds) {
        let self = new('zmd_RoundDelay');
        self.rounds = rounds;
        self.ticksLeft = delay;
        return self;
    }

    override void tick() {
        if (self.ticksLeft-- == 0) {
            self.rounds.startWorrying();
            self.destroy();
        }
    }
}

class zmd_RoundHud : zmd_HudItem {
    const fadeInDelay = 35 * 2;
    const fadeOutDelay = 35 * 5;
    const flashDelay = 35;

    zmd_Rounds rounds;
    bool isTransitioning;
    int ticksSinceTransition;
    int color;
    double alpha;

    override void beginPlay() {
        self.rounds = zmd_Rounds.fetch();
        self.ticksSinceTransition = self.fadeInDelay;
        self.color = Font.cr_red;
    }

    override void update() {
        if (self.rounds.isTransitioning) {
            if (self.ticksSinceTransition == self.fadeOutDelay) {
                self.alpha = 0.0;
                self.color = Font.cr_red;
            } else if (self.ticksSinceTransition < self.fadeOutDelay) {
                ++self.ticksSinceTransition;
                self.alpha = abs((self.ticksSinceTransition % (self.flashDelay * 2) - self.flashDelay) / double(self.flashDelay));
                self.color = Font.cr_untranslated;
            }
        } else if (self.ticksSinceTransition != 0) {
            if (self.ticksSinceTransition == self.fadeOutDelay)
                self.ticksSinceTransition = self.fadeInDelay;
            --self.ticksSinceTransition;
            self.alpha = (self.fadeInDelay - self.ticksSinceTransition) / double(self.fadeInDelay);
        }
    }

    override void draw(zmd_Hud hud, int state, double tickFrac) {
        hud.drawString(hud.defaultFont, ''..self.rounds.currentRound, (hud.right_margin - 10, hud.margin), hud.di_screen_right_top | hud.di_item_right_top, translation: self.color, alpha: self.alpha);
    }
}