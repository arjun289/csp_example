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

    # this gives a "preference against :red"
    for v <- variables do
      problem
      |> post(v, fn
        :red -> 1
        _ -> 0
      end)
    end

    problem
    |> Aruspex.Strategy.SimulatedAnnealing.set_strategy()
  end
end
