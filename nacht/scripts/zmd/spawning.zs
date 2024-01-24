class zmd_Spawner : Actor {
    void spawnIn(int health, zmd_PowerupHandler powerups) {
        let zombie = self.spawn("zmd_Zombie", self.pos, allow_replace);
        zombie.health = health;
        zmd_Zombie(zombie).powerups = powerups;
    }
}

class zmd_Spawning : EventHandler {
    const minDelay = 30;
    const maxDelay = 70;

    zmd_Rounds rounds;
    zmd_PowerupHandler powerups;
    Array<int> spawnerIds;
    Array<zmd_Spawner> spawners;
    int tickCount;
    bool isStopped;
    int delay;

    static void addSpawners(int tid) {
        let spawning = zmd_Spawning(EventHandler.find("zmd_Spawning"));

        if (spawning.spawnerIds.find(tid) == spawning.spawnerIds.size()) {
            spawning.spawnerIds.push(tid);
            let iterator = Level.createActorIterator(tid, "zmd_Spawner");
            zmd_Spawner spawner;
            while (spawner = zmd_Spawner(iterator.next())) {
                spawning.spawners.push(spawner);
            }
        }
    }

    void nextDelay() {
        self.delay = random[randomSpawning](minDelay, maxDelay);
    }

    void init() {
        self.rounds = new("zmd_Rounds");
        self.powerups = zmd_PowerupHandler(EventHandler.find('zmd_PowerupHandler'));
        self.nextDelay();
        self.isStopped = false;
        self.rounds.powerups = self.powerups;
    }

    override void worldTick() {
        if (!self.isStopped && self.rounds.readyToSpawn()) {
            self.delay--;
            if (self.delay == 0 && self.spawners.size() != 0) {
                self.spawners[random[randomSpawning](0, self.spawners.size() - 1)].spawnIn(self.rounds.zombieHealth, self.powerups);
                ++self.rounds.liveZombies;
                --self.rounds.unspawnedZombies;
                nextDelay();
            }
        }
    }

    override void worldLoaded(WorldEvent e) {
        zmd_Spawning.addSpawners(5);
    }
}