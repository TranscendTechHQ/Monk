/* generated using openapi-typescript-codegen -- do not edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { routes__admin__routers__UsersResponse } from '../models/routes__admin__routers__UsersResponse';
import type { TenantsResponse } from '../models/TenantsResponse';
import type { CancelablePromise } from '../core/CancelablePromise';
import { OpenAPI } from '../core/OpenAPI';
import { request as __request } from '../core/request';
export class AdminService {
    /**
     * Get all tenants
     * The API will return all tenants from SuperTokens
     * @returns TenantsResponse List of all tenants
     * @throws ApiError
     */
    public static getAllTenants(): CancelablePromise<TenantsResponse> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/admin/tenants',
        });
    }
    /**
     * Get all users
     * The API will return all users from SuperTokens
     * @returns routes__admin__routers__UsersResponse List of all users
     * @throws ApiError
     */
    public static getAllUsers(): CancelablePromise<routes__admin__routers__UsersResponse> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/admin/users',
        });
    }
}
