with games as (
    select *
    from {{ ref('stg_march_madness__games') }}
),

winning_teams as (
    select
        game_id,
        year as tournament_year,
        round_of,
        round_name,
        winning_team_name as team_name,
        winning_team_seed as team_seed,
        winning_team_score as team_score,
        losing_team_name as opponent_name,
        losing_team_seed as opponent_seed,
        losing_team_score as opponent_score,
        true as is_winner,
        point_differential,
        is_upset,
        winning_team_seed > losing_team_seed as is_underdog
    from games
),

losing_teams as (
    select
        game_id,
        year as tournament_year,
        round_of,
        round_name,
        losing_team_name as team_name,
        losing_team_seed as team_seed,
        losing_team_score as team_score,
        winning_team_name as opponent_name,
        winning_team_seed as opponent_seed,
        winning_team_score as opponent_score,
        false as is_winner,
        -1 * point_differential as point_differential,
        false as is_upset,
        losing_team_seed > winning_team_seed as is_underdog
    from games
)

select *
from winning_teams

union all

select *
from losing_teams
