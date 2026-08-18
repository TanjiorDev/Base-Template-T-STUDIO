-- Messages - the SMS / iMessage backend. Conversations are per-character
-- mailboxes stored in phone_messages; group threads live in the
-- phone_message_groups / phone_message_group_members tables. All three are
-- created on resource start.
return {
    -- Max characters in a single message body. Longer bodies are truncated.
    MaxBodyLength = 1000,

    -- Hard cap on stored messages per conversation (per character). Older
    -- messages are pruned past this so a thread can't grow unbounded.
    MessagesPerThread = 200,

    -- Group thread limits.
    MaxGroupNameLength = 40,
    MaxGroupMembers    = 16,   -- including the creator
}
