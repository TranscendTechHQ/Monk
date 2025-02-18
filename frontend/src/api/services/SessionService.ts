/* generated using openapi-typescript-codegen -- do not edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { SessionInfo } from '../models/SessionInfo';
import type { CancelablePromise } from '../core/CancelablePromise';
import { OpenAPI } from '../core/OpenAPI';
import { request as __request } from '../core/request';
export class SessionService {
    /**
     * Secure Api
     * @returns SessionInfo Successful Response
     * @throws ApiError
     */
    public static secureApiSessioninfoGet(): CancelablePromise<SessionInfo> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/sessioninfo',
        });
    }
}
