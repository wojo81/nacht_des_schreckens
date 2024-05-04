class zmd_Spawner : Actor {
    zmd_Spawning spawning;

    void spawnIn(zmd_Spawning spawning, int health) {
        self.spawning = spawning;
        let zombie = Actor.spawn(self.spawning.useVariedZombies? 'zmd_VariedZombie': 'zmd_Zombie', self.pos, allow_replace);
        zombie.bdropoff = true;
        zombie.health = health;
        zombie.changeTid(zmd_Spawning.regularTid);
        thing_hate(zmd_Spawning.regularTid, zmd_Player.liveTid, 0);
    }
}

class zmd_VariedZombie : RandomSpawner {
    Default {
        DropItem 'ShotgunGuy';
        DropItem 'DoomImp';
        DropItem 'Demon';
        DropItem 'ChaingunGuy';
        DropItem 'ZombieMan';
        DropItem 'Revenant';
    }
}

class zmd_Spawning : EventHandler {
    const regularTid = 115;
    const initialSpawnersTid = 5;
    const minDelay = 30;
    const maxDelay = 70;

    bool useVariedZombies;

    zmd_Rounds rounds;
    zmd_DropPool dropPool;
    Array<int> spawnerTids;
    Array<zmd_Spawner> spawners;
    int ticksTillSpawn;
    bool paused;

    static zmd_Spawning fetch() {
        return zmd_Spawning(EventHandler.find('zmd_Spawning'));
    }

    static zmd_Spawning init(zmd_Rounds rounds) {
        let self = zmd_Spawning.fetch();
        self.rounds = rounds;
        self.dropPool = rounds.dropPool;
        self.countdownSpawn();
        return self;
    }

    static void addSpawners(int tid) {
        let spawning = zmd_Spawning.fetch();

        if (spawning.spawnerTids.find(tid) == spawning.spawnerTids.size()) {
            spawning.spawnerTids.push(tid);
            let iterator = Level.createActorIterator(tid, 'zmd_Spawner');
            zmd_Spawner spawner;
            while (spawner = zmd_Spawner(iterator.next()))
                spawning.spawners.push(spawner);
        }
    }

    override void worldTick() {
        if (!self.paused && self.rounds.readyToSpawn()) {
            if (self.ticksTillSpawn-- == 0 && self.spawners.size() != 0) {
                self.spawners[random[randomSpawning](0, self.spawners.size() - 1)].spawnIn(self, self.rounds.zombieHealth);
                ++self.rounds.liveZombies;
                --self.rounds.unspawnedZombies;
                self.countdownSpawn();
            }
        }
    }

    override void worldLoaded(WorldEvent e) {
        zmd_Spawning.addSpawners(self.initialSpawnersTid);
        self.useVariedZombies = CVar.getCVar('useVariedZombies').getBool();
    }

    void countdownSpawn() {
        self.ticksTillSpawn = random[randomSpawning](self.minDelay, self.maxDelay);
    }
}