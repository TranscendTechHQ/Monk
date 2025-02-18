/* generated using openapi-typescript-codegen -- do not edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { CancelablePromise } from '../core/CancelablePromise';
import { OpenAPI } from '../core/OpenAPI';
import { request as __request } from '../core/request';
export class DefaultService {
    /**
     * Healthcheck
     * @returns any Successful Response
     * @throws ApiError
     */
    public static healthcheckHealthcheckGet(): CancelablePromise<any> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/healthcheck',
        });
    }
    /**
     * Get Link Meta
     * @param url
     * @returns any Successful Response
     * @throws ApiError
     */
    public static getLinkMetaLinkmetaGet(
        url: string,
    ): CancelablePromise<any> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/linkmeta',
            query: {
                'url': url,
            },
            errors: {
                422: `Validation Error`,
            },
        });
    }
}
