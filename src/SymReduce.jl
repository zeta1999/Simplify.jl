module SymReduce

export Patterns, @term, normalize


include("patterns/Patterns.jl")
using .Patterns

include("rules.jl")


normalize(rs) = Base.Fix2(normalize, rs)
function normalize(t::Term, (l, r)::Pair)
    σ = match(l, t)
    σ === nothing && return t
    σ(r)
end
function normalize(t::Term, rs)
    while true
        t = map(normalize(rs), t)
        t′ = foldl(normalize, t, rs)
        t == t′ && return t
        t = t′
    end
end
normalize(t::Term) = normalize(t, rules())

end # module
