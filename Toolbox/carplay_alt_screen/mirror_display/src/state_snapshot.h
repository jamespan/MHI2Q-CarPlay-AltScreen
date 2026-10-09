#ifndef ALTSCREEN_STATE_SNAPSHOT_H
#define ALTSCREEN_STATE_SNAPSHOT_H

#include <stdio.h>

struct StateSnapshotResult {
    bool published;
    const char *stage;
    int error;
};

/* A failed update must leave the last complete snapshot in place. */
StateSnapshotResult write_state_snapshot(const char *path, const char *data,
                                         size_t bytes);

class StateSnapshotPublisher {
public:
    StateSnapshotPublisher();
    bool publish(const char *path, const char *data, size_t bytes,
                 unsigned long long monotonic_ms);
private:
    unsigned long attempts_;
    unsigned long failures_;
    unsigned long consecutive_failures_;
    unsigned long long last_error_log_ms_;
    bool have_error_log_;
    bool have_success_log_;
};

#endif
