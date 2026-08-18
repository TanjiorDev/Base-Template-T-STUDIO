-- Radio app - numeric frequencies carried over pma-voice. RestrictedRanges gates
-- frequency bands to specific jobs: a frequency inside a listed range can only be
-- tuned by a player whose job is in that range's `jobs`. Ranges are inclusive and
-- may overlap (a player passes if they match ANY covering range); frequencies not
-- covered by any range are open to everyone. Leave the list empty for no limits.
return {
    RestrictedRanges = {
        { min = 1.0,  max = 10.0, jobs = { 'police' },                label = 'Police' },
        -- { min = 10.1, max = 20.0, jobs = { 'ambulance', 'doctor' },   label = 'EMS' },
    },
}
