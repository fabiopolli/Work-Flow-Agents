*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    OperatingSystem
Library    BuiltIn

*** Variables ***
${BASE_URL}    ${ENV_BASE_URL}

*** Keywords ***
Create API Session
    [Arguments]    ${base}=${BASE_URL}
    Create Session    api    ${base}

Auth Header
    [Arguments]    ${token}
    ${h}=    Create Dictionary    Authorization=Bearer ${token}
    [Return]    ${h}

Set Default Headers
    [Arguments]    ${headers}
    Set Suite Variable    ${DEFAULT_HEADERS}    ${headers}

GET 200 JSON Should Match
    [Arguments]    ${path}    ${json_path}    ${expected}
    ${resp}=    GET On Session    api    ${path}    headers=${DEFAULT_HEADERS}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${data}=    Evaluate    __import__('json').loads(${resp.text})
    ${val}=    Set Variable    ${data}[${json_path}]
    Should Be Equal    ${val}    ${expected}
