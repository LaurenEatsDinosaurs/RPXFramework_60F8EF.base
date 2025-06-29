if not lib then return end

local Query = {
	SELECT_STASH = 'SELECT data FROM inventory_stashes WHERE owner = ? AND name = ?',
	UPDATE_STASH = 'INSERT INTO inventory_stashes (owner, name, data) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE data = VALUES(data)',
	SELECT_PLAYER = 'SELECT inventory FROM `{user_table}` WHERE `{user_column}` = ?',
	UPDATE_PLAYER = 'UPDATE `{user_table}` SET inventory = ? WHERE `{user_column}` = ?',
}

Citizen.CreateThreadNow(function()
	local playerTable, playerColumn

	-- RPX ONLY
	playerTable = 'characters'
	playerColumn = 'citizenid'


	for k, v in pairs(Query) do
		Query[k] = v:gsub('{user_table}', playerTable):gsub('{user_column}', playerColumn)
	end

	Wait(0)

	local success, result = pcall(MySQL.scalar.await, 'SELECT 1 FROM inventory_stashes')

	if not success then
		MySQL.query([[CREATE TABLE `inventory_stashes` (
			`owner` varchar(60) DEFAULT NULL,
			`name` varchar(100) NOT NULL,
			`data` longtext DEFAULT NULL,
			`lastupdated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
			UNIQUE KEY `owner` (`owner`,`name`)
		)]])
	end

	success, result = pcall(MySQL.scalar.await, ('SELECT inventory FROM `%s`'):format(playerTable))

	if not success then
		return MySQL.query(('ALTER TABLE `%s` ADD COLUMN `inventory` LONGTEXT NULL'):format(playerTable))
	end
end)

db = {}

function db.loadPlayer(identifier)
	local inventory = MySQL.prepare.await(Query.SELECT_PLAYER, { identifier }) --[[@as string?]]
	return inventory and json.decode(inventory)
end

function db.savePlayer(owner, inventory)
	return MySQL.prepare(Query.UPDATE_PLAYER, { inventory, owner })
end

function db.saveStash(owner, dbId, inventory)
	return MySQL.prepare(Query.UPDATE_STASH, { owner or '', dbId, inventory })
end

function db.loadStash(owner, name)
	return MySQL.prepare.await(Query.SELECT_STASH, { owner or '', name })
end

function db.saveInventories(players, stashes)
	local numPlayer, numStash = #players, #stashes

	if numPlayer > 0 then
		MySQL.prepare(Query.UPDATE_PLAYER, players)
	end

	if numStash > 0 then
		MySQL.prepare(Query.UPDATE_STASH, stashes)
	end

	local total = numPlayer + numStash

	if total > 0 then
		shared.info(('Saving %s inventories to the database'):format(total))
	end
end

return db
