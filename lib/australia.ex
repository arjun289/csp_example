defmodule Australia do
  import Aruspex.Problem, only: [new: 0, add_variable: 3, post: 4, post: 3]
  
  def the_problem do
    variables = [
      wa  = :western_australia,
      nt  = :nothern_territory,
      q   = :queensland,
      sa  = :south_australia,
      nsw = :new_south_wales,
      v   = :victoria,
      t   = :tasmania
    ]

    domain = [:red, :green, :blue]
    problem = new()
    Enum.map variables, &add_variable(problem, &1, domain)

    problem
    |> post(wa, nt, &!=/2)
    |> post(wa, sa, &!=/2)
    |> post(sa, nt, &!=/2)
    |> post(sa, q, &!=/2)
    |> post(sa, nsw, &!=/2)
    |> post(sa, v, &!=/2)
    |> post(nt, q, &!=/2)
    |> post(q, nsw, &!=/2)
    |> post(nsw, v, &!=/2)

    # prefer blues so that we have plenty of them
    for v <- variables do
      problem
      |> post(v, fn
        :blue -> 0
        _ -> 1
      end)
    end
    
    # exactly 3 blues!
    problem
    |> post(variables, fn vars ->
      blue_count =
        Enum.count(vars, fn
          :blue -> true
          _ -> false
        end)
      blue_count == 3
    end)
  end

  def solve(problem) do
    problem
    |> Aruspex.Strategy.SimulatedAnnealing.set_strategy()
    |> Enum.take(1)
  end

  def solve!(problem) do
    Stream.repeatedly(fn -> solve(problem) end)
    |> Stream.with_index()
    |> Enum.reduce_while(nil, fn
      {[], index}, acc when index < 3 ->
        {:cont, nil}
      {[], index}, acc ->
        {:halt, :exhausted}
      {[solution], index}, acc ->
        {:halt, {solution, index}}
    end)
  end
end
