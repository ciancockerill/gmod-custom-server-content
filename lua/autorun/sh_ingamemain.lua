DGInGame = DGInGame or {}

----- Table of Jobs ------

DGInGame.GeneralJobs = {
	"field marshal",
	"general",
	"lieutenant general",
	"major general",
}

DGInGame.GeneralStaff = {
	"staff warrant officer",
	"staff  lieutenant",
	"staff captain",
	"staff major",
	"staff lieutenant colonel",
	"staff colonel",
	"staff brigadier",
	"staff major general",
	"lieutenant general",
	"general",
	"field marshal",
	"army medical command staff",		
	"special branch commander",
	"special branch senior investigator",
	"special branch investigator",
	"special group commander",
	"special group operative",
}

----- GLOBAL FUNCTIONS -----

function DGInGame.MRSRank(ply)

	local group = MRS.GetNWdata(ply, "Group")
	local rank = MRS.GetNWdata(ply, "Rank")
		
	if not MRS.Ranks[group] or not MRS.Ranks[group].ranks[rank] then
		return "Civilian"
	end

	return MRS.Ranks[group].ranks[rank].name

end 

function DGInGame.GetJob(ply)
	return ply:getDarkRPVar("job")
end 

----- Rank Functions -----
function DGInGame.IsGeneralJob(ply)
	return table.HasValue(DGInGame.GeneralJobs, string.lower(DGInGame.GetJob(ply)))
end

function DGInGame.IsGeneralStaffJob(jobName)
	return table.HasValue(DGInGame.GeneralStaff, string.lower(DGInGame.GetJob(ply)))
end
