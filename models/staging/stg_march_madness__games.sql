with source as (
    select *
    from {{ ref('march_madness_games') }}
),

renamed as (
    select
        cast(year as integer) as year,
        cast(round_of as integer) as round_of,
        winning_team_name,
        winning_team_seed,
        winning_team_score,
        losing_team_name,
        losing_team_seed,
        losing_team_score
    from source
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key([
            'year',
            'round_of',
            'winning_team_name',
            'losing_team_name'
        ]) }} as game_id,
        year,
        round_of,
        case round_of
            when 64 then 'First Round'
            when 32 then 'Second Round'
            when 16 then 'Sweet Sixteen'
            when 8 then 'Elite Eight'
            when 4 then 'Final Four'
            when 2 then 'Championship'
        end as round_name,
        winning_team_name,
        winning_team_seed,
        winning_team_score,
        losing_team_name,
        losing_team_seed,
        losing_team_score,
        winning_team_score - losing_team_score as point_differential,
        losing_team_seed < winning_team_seed as is_upset,
        losing_team_seed - winning_team_seed as seed_differential
    from renamed
)

select *
from final
