-- ============================================================
-- BLOODLEAK PREMIUM 2026 — DATABASE SCHEMAS FOR BLOODGARAGE
-- ============================================================

-- 1. Table structure for custom garages persistence layer
-- Stores custom garage/impound positions, NPCs, and spawn coordinates
CREATE TABLE IF NOT EXISTS `bl_garages` (
    `id` VARCHAR(50) NOT NULL,
    `data` LONGTEXT NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 2. Owned Vehicles Column Check
-- The script automatically adds this column on startup if it's missing,
-- but you can run it manually here to ensure compatibility with owned vehicles tracking:
-- ALTER TABLE `owned_vehicles` ADD COLUMN `garage` VARCHAR(50) DEFAULT 'Legion';
