-- The rows are Refund Requests (pending, approved or declined), not Refunds.
-- SQLite cannot change a column default in place, so the table is rebuilt.
CREATE TABLE `refund_requests` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`purchase_id` integer NOT NULL,
	`status` text DEFAULT 'pending' NOT NULL,
	`reason` text NOT NULL,
	`amount_refunded` integer,
	`requested_at` text NOT NULL,
	`resolved_at` text,
	`resolved_by_user_id` integer,
	FOREIGN KEY (`purchase_id`) REFERENCES `purchases`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`resolved_by_user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
INSERT INTO `refund_requests` (`id`, `purchase_id`, `status`, `reason`, `amount_refunded`, `requested_at`, `resolved_at`, `resolved_by_user_id`)
SELECT `id`, `purchase_id`, CASE `status` WHEN 'requested' THEN 'pending' ELSE `status` END, `reason`, `amount_refunded`, `requested_at`, `resolved_at`, `resolved_by_user_id`
FROM `refunds`;
--> statement-breakpoint
DROP TABLE `refunds`;
--> statement-breakpoint
CREATE INDEX `refund_requests_purchase_idx` ON `refund_requests` (`purchase_id`);
