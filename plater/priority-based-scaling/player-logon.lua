function f(modTable)
	local specId = PlayerUtil.GetCurrentSpecID()
	local isRdps, isTank, isMdps, isHealer = modTable.determinePlayerMetaInformation(specId)

	modTable.playerMetaInformation.specId = specId
	modTable.playerMetaInformation.isRdps = isRdps
	modTable.playerMetaInformation.isTank = isTank
	modTable.playerMetaInformation.isMdps = isMdps
	modTable.playerMetaInformation.isHealer = isHealer

	modTable.compile(true)
end
