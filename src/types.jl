# gco types
const GCObool = Cuchar
const GCOnode_id = Cint
const GCOLabelID = Cint
const GCOEnergyTermType = Cint
const GCOEnergyType = Union{Cint, Clonglong}
const GCOVarID = GCOnode_id
const GCOSiteID = GCOVarID

# gco structs
struct GCOSparseDataCost
    site::GCOSiteID
    cost::GCOEnergyTermType
end
