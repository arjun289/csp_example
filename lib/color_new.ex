defmodule ColorNew do

  def new() do
    import Aruspex.Problem
    import Aruspex.Strategy
    use Bitwise
    # domain = ~w(white black)a

    domain = [true, false]
    
    vars = [
      p1: %{fulfill: 2}, 
      p2: %{fulfill: 4}, 
      p3: %{fulfill: 1}, 
      p4: %{fulfill: 2}
    ]

    problem = Aruspex.Problem.new

    Enum.map vars, &add_variable(problem, &1, domain)

    graph = [["p1","p2"], ["p1", "p3"], ["p2","p3"], ["p2", "p4"]]

    problem
      |> post(:p1, :p2, & not(&1 and &2))
      |> post(:p1, :p3, & not(&1 and &2))
      |> post(:p2, :p3, & not(&1 and &2))
      |> post(:p2, :p4, & not(&1 and &2))
      # |> post([:p1, :p2, :p3, :p4], fn variables -> 
      #   Enum.filter()
      # end)

    result = problem |> Aruspex.Strategy.SimulatedAnnealing.set_strategy() |> Enum.take(1)
  end

  def xored(a,b) do
    ((not a) and b) or (a and (not b))
  end
end

