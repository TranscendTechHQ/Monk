from fastapi import APIRouter, Depends, HTTPException, status, Request
from supertokens_python.recipe.session.framework.fastapi import verify_session
from supertokens_python.recipe.session import SessionContainer
from supertokens_python.recipe import emailpassword, thirdparty
from utils.db import list_tenants
from typing import List, Optional, Dict, Any
from pydantic import BaseModel
import asyncio
import logging
import time
from utils.db import get_tenant_id

router = APIRouter()
logger = logging.getLogger(__name__)

class UserInfo(BaseModel):
    id: str
    email: str
    name: Optional[str] = None
    timeJoined: int
    tenantIds: Optional[List[str]] = None
    loginMethods: Optional[List[str]] = None
    verified: Optional[bool] = None

class UsersResponse(BaseModel):
    users: List[UserInfo]

class TenantInfo(BaseModel):
    tenantId: str
    name: str
    userCount: Optional[int] = None
    createdAt: Optional[int] = None

class TenantsResponse(BaseModel):
    tenants: List[TenantInfo]

@router.get("/users",
            response_model=UsersResponse,
            response_description="List of all users",
            operation_id="get_all_users",
            summary="Get all users",
            description="The API will return all users from SuperTokens")
async def get_all_users(request: Request, session: SessionContainer = Depends(verify_session())):
    # In a production environment, you should check if the user is an admin
    # For example:
    # user_id = await session.get_user_id()
    # is_admin = await check_if_user_is_admin(user_id)
    # if not is_admin:
    #     raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not authorized")
    
    try:
        # Get all users from MongoDB instead of directly from SuperTokens
        from utils.db import asyncdb
        users_collection = asyncdb.users_collection
        mongo_users = await users_collection.find().to_list(length=100)
        
        # Format users
        all_users = []
        
        for user in mongo_users:
            # Get tenant IDs for this user
            tenant_ids = await get_tenant_ids_for_user(user["_id"])
            
            # Determine login method based on available fields
            login_methods = []
            if "email" in user:
                login_methods.append("emailpassword")
            if "third_party_info" in user:
                login_methods.append("thirdparty")
                
            # Default to True for verified status if not available
            verified = user.get("email_verified", True)
            
            all_users.append(UserInfo(
                id=user["_id"],
                email=user.get("email", ""),
                name=user.get("name", None),
                timeJoined=user.get("time_joined", int(time.time() * 1000)),
                tenantIds=tenant_ids,
                loginMethods=login_methods,
                verified=verified
            ))
        
        return UsersResponse(users=all_users)
        
    except Exception as e:
        logger.error(f"Error fetching users: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error fetching users: {str(e)}"
        )

@router.get("/tenants",
            response_model=TenantsResponse,
            response_description="List of all tenants",
            operation_id="get_all_tenants",
            summary="Get all tenants",
            description="The API will return all tenants from SuperTokens")
async def get_all_tenants(request: Request, session: SessionContainer = Depends(verify_session())):
    # In a production environment, you should check if the user is an admin
    # For example:
    # user_id = await session.get_user_id()
    # is_admin = await check_if_user_is_admin(user_id)
    # if not is_admin:
    #     raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not authorized")
    
    try:
        # Get all tenants from SuperTokens
        tenants_response = await list_tenants()
        
        # Format tenants
        formatted_tenants = []
        
        # The response structure might be different than expected
        # Check if tenants_response is a dict with a 'tenants' key
        if hasattr(tenants_response, 'tenants'):
            tenants_list = tenants_response.tenants
        elif isinstance(tenants_response, list):
            tenants_list = tenants_response
        elif isinstance(tenants_response, dict) and 'tenants' in tenants_response:
            tenants_list = tenants_response['tenants']
        else:
            # If we can't determine the structure, log it and use an empty list
            logger.error(f"Unexpected tenants response structure: {tenants_response}")
            tenants_list = []
        
        for tenant in tenants_list:
            # Extract tenant_id based on the structure
            if hasattr(tenant, 'tenant_id'):
                tenant_id = tenant.tenant_id
            elif isinstance(tenant, dict) and 'tenant_id' in tenant:
                tenant_id = tenant['tenant_id']
            elif isinstance(tenant, dict) and 'tenantId' in tenant:
                tenant_id = tenant['tenantId']
            else:
                # If we can't determine the tenant_id, log it and skip this tenant
                logger.error(f"Could not determine tenant_id for tenant: {tenant}")
                continue
            
            # Get user count for this tenant
            user_count = await get_user_count_for_tenant(tenant_id)
            
            # Use current timestamp as creation time if not available
            created_at = int(time.time() * 1000)
            
            formatted_tenants.append(TenantInfo(
                tenantId=tenant_id,
                name=tenant_id.capitalize(),  # Use tenant ID as name if not available
                userCount=user_count,
                createdAt=created_at
            ))
        
        return TenantsResponse(tenants=formatted_tenants)
    
    except Exception as e:
        logger.error(f"Error fetching tenants: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error fetching tenants: {str(e)}"
        )

async def get_tenant_ids_for_user(user_id: str) -> List[str]:
    """
    Get all tenant IDs associated with a user.
    This is a placeholder - implement according to your tenant management system.
    """
    # This is a placeholder implementation
    # In a real application, you would query your database to find all tenants
    # that this user belongs to
    
    # For now, we'll return a hardcoded tenant ID for demonstration
    return ["public"]

async def get_user_count_for_tenant(tenant_id: str) -> int:
    """
    Get the number of users in a tenant.
    This is a placeholder - implement according to your tenant management system.
    """
    # This is a placeholder implementation
    # In a real application, you would query your database to count users in this tenant
    
    # For now, we'll return a random number for demonstration
    import random
    return random.randint(1, 100) 