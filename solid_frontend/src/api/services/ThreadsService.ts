/* generated using openapi-typescript-codegen -- do not edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { MessageCreate } from '../models/MessageCreate';
import type { MessageResponse } from '../models/MessageResponse';
import type { MessagesResponse } from '../models/MessagesResponse';
import type { ThreadCreate } from '../models/ThreadCreate';
import type { ThreadResponse } from '../models/ThreadResponse';
import type { ThreadsResponse } from '../models/ThreadsResponse';
import type { UserMap } from '../models/UserMap';
import type { CancelablePromise } from '../core/CancelablePromise';
import { OpenAPI } from '../core/OpenAPI';
import { request as __request } from '../core/request';
export class ThreadsService {
    /**
     * Create a new message in a thread
     * The api will create a new message in a thread and return the newly created message
     * @param requestBody
     * @returns MessageResponse Newly created message
     * @throws ApiError
     */
    public static createMessage(
        requestBody: MessageCreate,
    ): CancelablePromise<MessageResponse> {
        return __request(OpenAPI, {
            method: 'POST',
            url: '/message',
            body: requestBody,
            mediaType: 'application/json',
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Get all messages in a thread
     * The api will return all messages in a thread
     * @param threadId
     * @returns MessagesResponse List of messages in a thread
     * @throws ApiError
     */
    public static getMessages(
        threadId: string,
    ): CancelablePromise<MessagesResponse> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/messages',
            query: {
                'thread_id': threadId,
            },
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Search Threads
     * @param query
     * @returns ThreadsResponse Search threads by query and get matching threads
     * @throws ApiError
     */
    public static searchThreadsSearchThreadsGet(
        query: string,
    ): CancelablePromise<ThreadsResponse> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/searchThreads',
            query: {
                'query': query,
            },
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Search Titles
     * @param query
     * @returns string Search threads by query and get topic
     * @throws ApiError
     */
    public static searchTitles(
        query: string,
    ): CancelablePromise<Array<string>> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/searchTitles',
            query: {
                'query': query,
            },
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Create a new thread
     * The api will create a new thread and return the newly created thread
     * @param requestBody
     * @returns ThreadResponse Newly created thread
     * @throws ApiError
     */
    public static createThread(
        requestBody: ThreadCreate,
    ): CancelablePromise<ThreadResponse> {
        return __request(OpenAPI, {
            method: 'POST',
            url: '/thread',
            body: requestBody,
            mediaType: 'application/json',
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Get all threads
     * The api will return all threads
     * @returns ThreadsResponse List of threads
     * @throws ApiError
     */
    public static getThreads(): CancelablePromise<ThreadsResponse> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/threads',
        });
    }
    /**
     * All Users
     * @returns UserMap Get user information
     * @throws ApiError
     */
    public static allUsersUserGet(): CancelablePromise<UserMap> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/user',
        });
    }
}
