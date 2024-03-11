class zmd_Rounds : Thinker {
    const maxHordeCount = 32;

    int currentRound;
    int zombieHealth;
    int unspawnedZombies;
    int liveZombies;
    int zombiesLeft;
    int tickCount;
    bool isTransitioning;

    zmd_DropHandler drops;

    zmd_RoundChangeSound roundChange;

    override void postBeginPlay() {
        currentRound = 0;
        nextRound();
    }

    int calcZombiesHealth() {
        return 25 + 20 * (currentRound - 1);
    }

    int calcZombiesCount() {
        return 4 + 3 * (currentRound - 1);
    }

    void nextRound() {
        currentRound += 1;
        zombieHealth = calcZombiesHealth();
        unspawnedZombies = calcZombiesCount();
        zombiesLeft = unspawnedZombies;
        isTransitioning = false;
        if (drops != null) {
            drops.resetCount();
        }

        if (currentRound == 2) {
            roundChange = zmd_RoundChangeSound(Level.createActorIterator(114, "zmd_RoundChangeSound").next());
            roundChange.playRound();
        } else if (currentRound != 1) {
            roundChange.playRound();
        }
    }

    void zombieKilled() {
        liveZombies--;
        zombiesLeft--;
    }

    bool roundOver() {
        return zombiesLeft == 0;
    }

    bool readyToSpawn() {
        return !isTransitioning && liveZombies != maxHordeCount && unspawnedZombies != 0;
    }
}

class zmd_RoundDelay : Thinker {
    zmd_Rounds rounds;
    int delay;

    override void postBeginPlay() {
        delay = 35 * 5;
    }

    override void tick() {
        --delay;
        if (delay == 0) {
            self.rounds.nextRound();
            self.destroy();
        }
    }
}

class zmd_RoundHandler : EventHandler {
    zmd_Rounds rounds;

    override void worldLoaded(WorldEvent e) {
        let spawning = zmd_Spawning(EventHandler.find('zmd_Spawning'));
        spawning.init();
        self.rounds = spawning.rounds;
    }

    override void worldThingDied(WorldEvent e) {
        if (e.thing && e.thing.bIsMonster) {
            rounds.zombieKilled();
            if (rounds.roundOver()) {
                rounds.isTransitioning = true;
                let round_delay = new('zmd_RoundDelay');
                round_delay.rounds = rounds;
            }
        }
    }

    override void worldTick() {
// 		console.printf("");
// 		console.printf("unspawned %d", rounds_.unspawnedZombies);
// 		console.printf("live zombies %d", rounds_.liveZombies);
//		console.printf("zombies left %d", rounds_.zombiesLeft);

        rounds.tickCount++;
        if (rounds.tickCount == 40) {
            rounds.tickCount = 0;
        }
    }
}

class zmd_RoundChangeSound : Actor {
    override void postBeginPlay() {
        thing_changeTID(0, 114);
        playIntro();
    }

    void playIntro() {
        a_startSound("game/intro", attenuation: attn_none);
    }

    void playRound() {
        a_startSound("game/round", attenuation: attn_none);
    }
}

class zmd_RoundHud : zmd_HudElement {
    zmd_Rounds rounds;

    override void draw(zmd_Hud hud, int state, double tickFrac) {
        hud.drawString(hud.defaultFont, ''..self.rounds.currentRound, (hud.right_margin - 10, hud.margin), hud.di_screen_right_top | hud.di_item_right_top, translation: Font.cr_darkRed);
    }
}