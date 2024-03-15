class zmd_GlobalSound : Actor {
    static zmd_GlobalSound create() {
        return zmd_GlobalSound(Actor.spawn('zmd_GlobalSound'));
    }

    void start(sound whatToPlay, int slot = chan_body, int flags = chanf_default, double volume = 1, double pitch = 0, double startTime = 0) {
        self.a_startSound(whatToPlay, slot, flags, volume, attn_none, pitch, startTime);
    }
}