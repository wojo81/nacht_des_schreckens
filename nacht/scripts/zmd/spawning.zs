class zmd_Spawner : Actor {
    void spawnIn(int health, zmd_DropHandler drops) {
        let zombie = self.spawn("zmd_Zombie", self.pos, allow_replace);
        zombie.health = health;
        zmd_Zombie(zombie).drops = drops;
    }
}

class zmd_Spawning : EventHandler {
    const minDelay = 30;
    const maxDelay = 70;

    zmd_Rounds rounds;
    zmd_DropHandler drops;
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
        self.drops = zmd_DropHandler(EventHandler.find('zmd_DropHandler'));
        self.nextDelay();
        self.isStopped = false;
        self.rounds.drops = self.drops;
    }

    override void worldTick() {
        if (!self.isStopped && self.rounds.readyToSpawn()) {
            self.delay--;
            if (self.delay == 0 && self.spawners.size() != 0) {
                self.spawners[random[randomSpawning](0, self.spawners.size() - 1)].spawnIn(self.rounds.zombieHealth, self.drops);
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