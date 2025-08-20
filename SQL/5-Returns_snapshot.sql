INSERT INTO
    livraria_dw.quality_check_runs (
        check_name,
        severity,
        is_pass,
        affected_cnt,
        details
    )
SELECT
    'returns_snapshot_now',
    'WARN',
    1,
    1,
    CONCAT(
        '{ "total_returns": ',
        (
            SELECT
                COUNT(*)
            FROM
                livraria_stg.returns
        ),
        ', "by_reason": {',
        '"Atraso": ',
        (
            SELECT
                COUNT(*)
            FROM
                livraria_stg.returns
            WHERE
                reason = 'Atraso'
        ),
        ', ',
        '"Arrependimento": ',
        (
            SELECT
                COUNT(*)
            FROM
                livraria_stg.returns
            WHERE
                reason = 'Arrependimento'
        ),
        ', ',
        '"Dano no Transporte": ',
(
            SELECT
                COUNT(*)
            FROM
                livraria_stg.returns
            WHERE
                reason = 'Dano no Transporte'
        ),
        ', ',
        '"Defeito": ',
        (
            SELECT
                COUNT(*)
            FROM
                livraria_stg.returns
            WHERE
                reason = 'Defeito'
        ),
        '} }'
    );

select
    *
from
    quality_check_runs;