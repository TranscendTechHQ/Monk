from pydantic import BaseModel


class WhitelistedUserModel(BaseModel):
    email: str
    tenant_id: str


class WhitelistedUsersListModel(BaseModel):
    whitelisted_users: list[WhitelistedUserModel]