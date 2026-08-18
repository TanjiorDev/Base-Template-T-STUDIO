-- Standing orders - the SOPs a department publishes to its own terminal.
--
-- A STATIC config, like the penal code. These are policy documents, not records: they are written
-- once by whoever runs the department and read by everyone else, so there is nothing to store and
-- nothing to sync. Edit this file and restart to publish.
--
--   code      the reference the SOP is cited by on a report; must be unique
--   title     what the order is called
--   terminal  'leo' | 'ems' - which terminal it appears on. Omit to publish it on both.
--   jobs      optional list of framework job names. When present ONLY those departments see it,
--             which is how one force keeps its own orders off another's terminal.
--   category  groups the list. Any string; the terminal builds its filter from what it finds.
--   summary   one line shown in the list
--   revised   free text, shown under the title so a reader can tell how current it is
--   body      the order itself. Supports the same formatting as a report narrative:
--             **bold**, *italic*, __underline__, ~~strike~~, `code`, and "- " bullet lines.

return {
    ----------------------------------------------------------------------------
    -- Police
    ----------------------------------------------------------------------------
    {
        code = 'SOP 100', terminal = 'leo', category = 'Conduct', revised = 'Revision 4',
        title = 'Use of Force',
        summary = 'The force continuum, and what has to be reported afterwards.',
        body = [[
Force used must be **objectively reasonable** for the resistance actually met, and it stops the moment the resistance does.

The continuum, in order:
- Presence and verbal direction
- Soft empty hand control
- Hard empty hand control
- Intermediate weapons
- Deadly force

Deadly force is authorised only against an immediate threat of death or serious bodily harm to yourself or another person. A fleeing suspect is not, by itself, that threat.

**After any force above verbal direction:**
- Render or summon medical aid before anything else
- Notify a supervisor on the air, not afterwards in person
- File a report the same shift, naming every officer present
- Do not review body camera footage with another involved officer before your statement is written
]],
    },
    {
        code = 'SOP 101', terminal = 'leo', category = 'Conduct', revised = 'Revision 2',
        title = 'Vehicle Pursuits',
        summary = 'When a pursuit may start, when it must be called off.',
        body = [[
A pursuit is justified only when the offence in hand is **serious enough to outweigh the risk** the pursuit itself creates. Speeding alone is not.

Before you call it in, decide:
- What you are pursuing for
- Road, traffic and weather conditions
- Whether the suspect is already identified, in which case a pursuit is rarely worth it

The primary unit calls the pursuit and gives direction, speed and street names. The secondary handles the radio. **No more than two units** join without supervisory approval.

A supervisor may terminate at any time, and a termination is absolute: acknowledge it and disengage, do not shadow the vehicle.

Terminate on your own initiative when speeds outrun conditions, when you lose sight for a sustained period, or when the pursuit enters a crowded area.
]],
    },
    {
        code = 'SOP 102', terminal = 'leo', category = 'Patrol', revised = 'Revision 1',
        title = 'Traffic Stops',
        summary = 'Positioning, approach, and what to call in before you leave the car.',
        body = [[
Call the stop in **before** you leave the vehicle: your location, the plate, and the number of occupants.

Position with an offset to the driver side and turn the wheels away from the lane. Approach on the passenger side where traffic makes the driver side unsafe.

State the reason for the stop first. A driver who knows why they were stopped argues less.

Escalate to a felony stop for a stolen vehicle, an occupied vehicle linked to a violent offence, or a confirmed warrant on an occupant. In that case: do not approach, direct the occupants back to you one at a time, and wait for a second unit.
]],
    },
    {
        code = 'SOP 103', terminal = 'leo', category = 'Custody', revised = 'Revision 3',
        title = 'Arrest and Booking',
        summary = 'From cuffs to cell, and the paperwork each step needs.',
        body = [[
Search every arrestee before they enter a vehicle, including one arrested by another officer. **Never accept that somebody else already searched them.**

Cuffs go on double locked and checked for fit. A complaint about tightness is checked, not argued with.

Read the caution before any questioning. If the arrestee asks for an attorney, questioning stops there.

At booking:
- Photograph and record the arrest on the person record
- List every charge from the penal code, not from memory
- A sentence and fine are what the terminal calculates; they are not negotiated at the desk
- Property is inventoried in front of the arrestee

Medical clearance is required before booking anyone who was subject to force, who is injured, or who appears intoxicated to the point of risk.
]],
    },
    {
        code = 'SOP 104', terminal = 'leo', category = 'Investigations', revised = 'Revision 2',
        title = 'Evidence Handling',
        summary = 'Chain of custody, and what breaks it.',
        body = [[
Evidence is photographed **in place** before it is moved. A photograph taken after the fact proves nothing about where the item was found.

Every transfer is recorded: who had it, who took it, and when. An unexplained gap in that chain is what a defence attorney is looking for, and it is usually enough.

Attach media to the report it belongs to rather than storing it loose. A report is the container the court reads.

Firearms are made safe by a second officer present as a witness, and the serial recorded before the weapon is bagged.
]],
    },
    {
        code = 'SOP 105', terminal = 'leo', category = 'Communications', revised = 'Revision 1',
        title = 'Radio Discipline',
        summary = 'Callsigns, status codes and priority traffic.',
        body = [[
Identify with your callsign first, then the message. Listen before transmitting; stepping on priority traffic is worse than waiting.

Status codes:
- `10-8` available
- `10-6` busy on a call
- `10-7` out of service
- `10-90` emergency, all other traffic stops

`10-90` is for an officer in immediate danger. Using it for anything else trains everybody to ignore it.

Keep plain language for anything a code does not cover exactly. A misunderstood code costs more than a longer sentence.
]],
    },
    {
        code = 'SOP 106', terminal = 'leo', category = 'Conduct', revised = 'Revision 1',
        title = 'Mental Health Calls',
        summary = 'De-escalation first, and when a crisis is not a crime.',
        body = [[
Slow the call down. Time is the tool that works; there is rarely a reason to force a resolution in the first minute.

- One officer speaks, the others stay back
- Turn off the lights and siren on approach where it is safe to
- Do not argue with a delusion and do not agree with one either
- Ask what would help, and mean it

Rule out the physical causes that look like a crisis, low blood sugar and head injury among them, before you treat it as one. Request EMS early rather than late.

Custody is the last option, not the first. Where no offence has been committed, the outcome should be care and not a cell.
]],
    },
    {
        code = 'SOP 107', terminal = 'leo', category = 'Records', revised = 'Revision 2',
        title = 'Report Writing',
        summary = 'What a narrative has to contain to survive a courtroom.',
        body = [[
Write in the **first person, past tense, and in the order it happened**. Anything else reads as reconstruction.

A narrative must answer: who, what, where, when, how you came to be there, and what you personally saw. Mark anything you were told rather than observed as exactly that.

Do not write conclusions. "He was nervous" is an opinion; "his hands were shaking and he looked repeatedly at the passenger footwell" is evidence.

Charges are attached from the penal code, and the terminal totals the sentence. Never write a figure into the narrative by hand: it will disagree with the record eventually, and the disagreement is what gets read out in court.

Attach every photograph, clip and document to the report itself rather than describing it.
]],
    },

    ----------------------------------------------------------------------------
    -- Medical
    ----------------------------------------------------------------------------
    {
        code = 'SOP 200', terminal = 'ems', category = 'Scene', revised = 'Revision 3',
        title = 'Scene Safety and Approach',
        summary = 'The scene comes before the patient, every time.',
        body = [[
**You are no use to the patient as a second casualty.** Do not enter a scene that is not safe, and do not let a bystander pressure you into it.

Stage away and request police for any scene involving a weapon, a threat of violence, or an unsecured hostile crowd. Staging is not abandoning the patient.

On arrival, before touching anyone:
- Note the number of patients and call for more units early
- Identify the mechanism of injury
- Identify your exit

Hazards travel. Traffic, fuel, live electricity and unstable structures do not stop being dangerous because a patient is in the middle of them.
]],
    },
    {
        code = 'SOP 201', terminal = 'ems', category = 'Scene', revised = 'Revision 2',
        title = 'Triage and Multiple Casualties',
        summary = 'Sorting when there are more patients than hands.',
        body = [[
The first unit on a multiple casualty scene **does not treat**. It counts, sorts and reports. Treating the first patient you reach is the most common way a mass casualty scene goes wrong.

Sort into:
- Immediate, life threat that can be fixed now
- Urgent, will deteriorate without care but has time
- Delayed, walking wounded
- Expectant, injuries not survivable with the resources present

Report the count and the breakdown before you begin treating. The count is what decides how many units come.

Re-triage on every pass. A delayed patient becomes an immediate one without warning.
]],
    },
    {
        code = 'SOP 202', terminal = 'ems', category = 'Legal', revised = 'Revision 4',
        title = 'Consent, Refusal and Capacity',
        summary = 'When a patient may say no, and what you record when they do.',
        body = [[
A competent adult may refuse **any** treatment, including treatment that will save them. That refusal is theirs to make and yours to record.

Capacity is decision specific and time specific. Establish that the patient understands what is wrong, what you are offering, and what happens if they decline. Intoxication does not automatically remove capacity, and being calm does not automatically prove it.

Consent is implied for a patient who is unconscious or otherwise unable to give it. Treat.

Every refusal is documented in a Patient Care report with:
- What you found and what you offered
- The risks you explained, in the words you used
- That you advised them to call again if anything changed

The report is the protection for both of you.
]],
    },
    {
        code = 'SOP 203', terminal = 'ems', category = 'Legal', revised = 'Revision 1',
        title = 'Death on Scene',
        summary = 'Recognition of life extinct, and the scene that follows.',
        body = [[
Resuscitation is not started where injuries are **incompatible with life**, where rigor or lividity is established, or where a valid DNR is presented.

Once recognised:
- Record the time of recognition, not the time of the incident
- Stop moving anything you do not have to move
- Hand the location over to police and stay until they arrive
- File the report under the Death type

Treat every unattended death as a scene until police say otherwise. What looks obvious at three in the morning has been wrong before.
]],
    },
    {
        code = 'SOP 204', terminal = 'ems', category = 'Clinical', revised = 'Revision 2',
        title = 'Handover',
        summary = 'The structured handover the receiving team expects.',
        body = [[
Hand over once, to the person taking the patient, without being interrupted. Ask for that thirty seconds if it is not offered.

In order:
- Age and sex
- What happened, briefly
- What you found, including the first set of observations
- What you did and what it changed
- What they need to know right now

Times matter more than adjectives. "Tourniquet on at 04:12" is worth more than "significant bleeding controlled".

Leave the written record with them before you leave the department.
]],
    },
    {
        code = 'SOP 205', terminal = 'ems', category = 'Clinical', revised = 'Revision 1',
        title = 'Controlled Drugs',
        summary = 'Two signatures, every time, no exceptions.',
        body = [[
Every controlled drug is drawn, checked and administered with a **second responder witnessing**, and both names go on the record.

Record the drug, the dose, the route and the time at the moment of administration and not at the end of the shift.

Wastage is witnessed and recorded the same way. An unexplained discrepancy is an Internal Affairs matter for the service, and it is treated as one.

Never carry a controlled drug off duty, and never leave one in an unattended vehicle.
]],
    },
}
