SELECT 
    pi.identifier AS 'EMR ID',
    CASE
        WHEN
            (DATE(BDQ.ND) IS NOT NULL)
                AND (DATE(DLM.ND) IS NOT NULL)
        THEN
            (LEAST(DATE(BDQ.ND), DATE(DLM.ND)))
        WHEN
            (DATE(BDQ.ND) IS NOT NULL)
                AND (DATE(DLM.ND) IS NULL)
        THEN
            DATE(BDQ.ND)
        WHEN
            (DATE(BDQ.ND) IS NULL)
                AND (DATE(DLM.ND) IS NOT NULL)
        THEN
            DATE(DLM.ND)
    END AS 'MIN DRUG START DATE',
    CASE
        WHEN DATE(BDQ.ND) > DATE(DLM.ND) THEN 'DLM'
        WHEN DATE(BDQ.ND) < DATE(DLM.ND) THEN 'BDQ'
        WHEN DATE(BDQ.ND) = DATE(DLM.ND) THEN 'BOTH'
        WHEN
            DATE(BDQ.ND) IS NULL
                AND DATE(DLM.ND) IS NULL
        THEN
            'NO NEW DRUG'
        WHEN DATE(BDQ.ND) IS NULL THEN 'DLM'
        WHEN DATE(DLM.ND) IS NULL THEN 'BDQ'
    END AS ND,
    DATE(BDQ.ND) AS BDQ,
    DATE(DLM.ND) AS DLM,
    DATE(CFZ.CFZ) AS CFZ,
    DATE(LZD.LZD) AS LZD,
    DATE(H.H) AS H,
    DATE(R.R) AS R,
    DATE(E.E) AS E,
    DATE(Z.Z) AS Z,
    DATE(S.S) AS S,
    DATE(Am.Am) AS Am,
    DATE(Km.Km) AS Km,
    DATE(Cm.Cm) AS Cm,
    DATE(Lfx.Lfx) AS Lfx,
    DATE(Mfx.Mfx) AS Mfx,
    DATE(Pto.Pto) AS Pto,
    DATE(Eto.Eto) AS Eto,
    DATE(Cs.Cs) AS Cs,
    DATE(Trd.Trd) AS Trd,
    DATE(PAS.PAS) AS PAS,
    DATE(PASNa.PASNa) AS 'PAS-Na',
    DATE(ImpCln.ImpCln) AS 'Imp/Cln',
    DATE(AmxClv.AmxClv) AS 'Amx/Clv',
    DATE(Mpm.Mpm) AS Mpm,
    DATE(Clr.Clr) AS Clr
FROM
    patient_identifier pi
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS ND
    FROM
        orders
    WHERE
        concept_id = 1251 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) BDQ ON pi.patient_id = BDQ.patient_id
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS ND
    FROM
        orders
    WHERE
        concept_id = 1252 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) DLM ON pi.patient_id = DLM.patient_id
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS CFZ
    FROM
        orders
    WHERE
        concept_id = 218 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) CFZ ON CFZ.patient_id = pi.patient_id
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS LZD
    FROM
        orders
    WHERE
        concept_id = 229 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) LZD ON LZD.patient_id = pi.patient_id
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS H
    FROM
        orders
    WHERE
        concept_id = 1225 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) H ON H.patient_id = pi.patient_id
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS R
    FROM
        orders
    WHERE
        concept_id = 1226 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) R ON R.patient_id = pi.patient_id
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS E
    FROM
        orders
    WHERE
        concept_id = 221 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) E ON E.patient_id = pi.patient_id
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS Z
    FROM
        orders
    WHERE
        concept_id = 237 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) Z ON Z.patient_id = pi.patient_id
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS S
    FROM
        orders
    WHERE
        concept_id = 242 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) S ON S.patient_id = pi.patient_id
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS Am
    FROM
        orders
    WHERE
        concept_id = 215 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) Am ON Am.patient_id = pi.patient_id
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS Km
    FROM
        orders
    WHERE
        concept_id = 227 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) Km ON Km.patient_id = pi.patient_id
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS Cm
    FROM
        orders
    WHERE
        concept_id = 219 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) Cm ON Cm.patient_id = pi.patient_id
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS Lfx
    FROM
        orders
    WHERE
        concept_id = 228 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) Lfx ON Lfx.patient_id = pi.patient_id
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS Mfx
    FROM
        orders
    WHERE
        concept_id = 231 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) Mfx ON Mfx.patient_id = pi.patient_id
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS Pto
    FROM
        orders
    WHERE
        concept_id = 236 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) Pto ON Pto.patient_id = pi.patient_id
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS Eto
    FROM
        orders
    WHERE
        concept_id = 223 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) Eto ON Eto.patient_id = pi.patient_id
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS Cs
    FROM
        orders
    WHERE
        concept_id = 220 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) Cs ON Cs.patient_id = pi.patient_id
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS Trd
    FROM
        orders
    WHERE
        concept_id = 244 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) Trd ON Trd.patient_id = pi.patient_id
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS PAS
    FROM
        orders
    WHERE
        concept_id = 235 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) PAS ON PAS.patient_id = pi.patient_id
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS PASNa
    FROM
        orders
    WHERE
        concept_id = 1227 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) PASNa ON PASNa.patient_id = pi.patient_id
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS ImpCln
    FROM
        orders
    WHERE
        concept_id = 1228 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) ImpCln ON ImpCln.patient_id = pi.patient_id
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS AmxClv
    FROM
        orders
    WHERE
        concept_id = 216 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) AmxClv ON AmxClv.patient_id = pi.patient_id
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS Mpm
    FROM
        orders
    WHERE
        concept_id = 230 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) Mpm ON Mpm.patient_id = pi.patient_id
        LEFT JOIN
    (SELECT 
        patient_id, MIN(scheduled_date) AS Clr
    FROM
        orders
    WHERE
        concept_id = 1258 AND voided = 0
            AND auto_expire_date IS NULL
    GROUP BY patient_id) Clr ON Clr.patient_id = pi.patient_id
ORDER BY pi.identifier;
