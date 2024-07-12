function f(self, unitId, unitFrame, envTable)
	function envTable.CheckAggro(unitFrame)
		--if the player isn't in combat, ignore this check
		if not Plater.IsInCombat() then
			return
		end

		--if this unit is a player, ignore
		if UnitPlayerControlled(unitFrame.unit) then
			return
		end

		--if this unit isn't in combat, ignore
		if not unitFrame.InCombat then
			return
		end

		--player is a tank?
		if Plater.PlayerIsTank then
			--player isn't tanking this unit?
			if not unitFrame.namePlateThreatIsTanking then
				--check if a second tank is tanking it
				if Plater.ZoneInstanceType == "raid" then
					--return a list with the name of tanks in the raid
					local tankPlayersInTheRaid = Plater.GetTanks()

					--get the target name of this unit
					local unitTargetName = UnitName(unitFrame.targetUnitID)

					--check if the unit isn't targeting another tank in the raid and paint the color
					if not tankPlayersInTheRaid[unitTargetName] then
						Plater.SetNameplateColor(unitFrame, Plater.db.profile.tank.colors.noaggro)
					else
						--another tank is tanking this unit
						--do nothing
					end
				else
					Plater.SetNameplateColor(unitFrame, Plater.db.profile.tank.colors.noaggro)
				end
			end
		else
			--player is a dps or healer
			if unitFrame.namePlateThreatIsTanking then
				Plater.SetNameplateColor(unitFrame, Plater.db.profile.dps.colors.aggro)
			end
		end
	end
end
