/* generated using openapi-typescript-codegen -- do not edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { BlockModel } from '../models/BlockModel';
import type { BlockWithCreator } from '../models/BlockWithCreator';
import type { CreateBlockModel } from '../models/CreateBlockModel';
import type { CreateChildThreadModel } from '../models/CreateChildThreadModel';
import type { CreateThreadModel } from '../models/CreateThreadModel';
import type { CreateUserThreadFlagModel } from '../models/CreateUserThreadFlagModel';
import type { FullThreadInfo } from '../models/FullThreadInfo';
import type { ThreadsInfo } from '../models/ThreadsInfo';
import type { ThreadsMetaData } from '../models/ThreadsMetaData';
import type { ThreadsModel } from '../models/ThreadsModel';
import type { UpdateBlockModel } from '../models/UpdateBlockModel';
import type { UpdateBlockPositionModel } from '../models/UpdateBlockPositionModel';
import type { UpdateThreadTitleModel } from '../models/UpdateThreadTitleModel';
import type { UserFilterPreferenceModel } from '../models/UserFilterPreferenceModel';
import type { UserMap } from '../models/UserMap';
import type { UserThreadFlagModel } from '../models/UserThreadFlagModel';
import type { CancelablePromise } from '../core/CancelablePromise';
import { OpenAPI } from '../core/OpenAPI';
import { request as __request } from '../core/request';
export class ThreadsService {
    /**
     * Create
     * @param threadTopic
     * @param requestBody
     * @returns BlockWithCreator Create a new block
     * @throws ApiError
     */
    public static createBlocksPost(
        threadTopic: string,
        requestBody: CreateBlockModel,
    ): CancelablePromise<BlockWithCreator> {
        return __request(OpenAPI, {
            method: 'POST',
            url: '/blocks',
            query: {
                'thread_topic': threadTopic,
            },
            body: requestBody,
            mediaType: 'application/json',
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Child Thread
     * @param requestBody
     * @returns FullThreadInfo Create a new child thread from a block
     * @throws ApiError
     */
    public static childThreadBlocksChildPost(
        requestBody: CreateChildThreadModel,
    ): CancelablePromise<FullThreadInfo> {
        return __request(OpenAPI, {
            method: 'POST',
            url: '/blocks/child',
            body: requestBody,
            mediaType: 'application/json',
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Update
     * @param id
     * @param threadTopic
     * @param requestBody
     * @returns BlockModel Update a block
     * @throws ApiError
     */
    public static updateBlocksIdPut(
        id: string,
        threadTopic: string,
        requestBody: UpdateBlockModel,
    ): CancelablePromise<BlockModel> {
        return __request(OpenAPI, {
            method: 'PUT',
            url: '/blocks/{id}',
            path: {
                'id': id,
            },
            query: {
                'thread_topic': threadTopic,
            },
            body: requestBody,
            mediaType: 'application/json',
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Update Block Assigned User
     * @param id
     * @param requestBody
     * @returns BlockWithCreator Assign the todo block to user
     * @throws ApiError
     */
    public static updateBlockAssignedUserBlocksIdAssignPut(
        id: string,
        requestBody: string,
    ): CancelablePromise<BlockWithCreator> {
        return __request(OpenAPI, {
            method: 'PUT',
            url: '/blocks/{id}/assign',
            path: {
                'id': id,
            },
            body: requestBody,
            mediaType: 'application/json',
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Update Block Due Date
     * @param id
     * @param requestBody
     * @returns BlockWithCreator Update a block due date
     * @throws ApiError
     */
    public static updateBlockDueDateBlocksIdDueDatePut(
        id: string,
        requestBody: string,
    ): CancelablePromise<BlockWithCreator> {
        return __request(OpenAPI, {
            method: 'PUT',
            url: '/blocks/{id}/dueDate',
            path: {
                'id': id,
            },
            body: requestBody,
            mediaType: 'application/json',
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Update Block Position
     * @param id
     * @param requestBody
     * @returns UpdateBlockPositionModel Update a block position
     * @throws ApiError
     */
    public static updateBlockPositionBlocksIdPositionPut(
        id: string,
        requestBody: UpdateBlockPositionModel,
    ): CancelablePromise<UpdateBlockPositionModel> {
        return __request(OpenAPI, {
            method: 'PUT',
            url: '/blocks/{id}/position',
            path: {
                'id': id,
            },
            body: requestBody,
            mediaType: 'application/json',
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Update Block Task Status
     * @param id
     * @param requestBody
     * @returns BlockWithCreator Update a block task status
     * @throws ApiError
     */
    public static updateBlockTaskStatusBlocksIdTaskStatusPut(
        id: string,
        requestBody: string,
    ): CancelablePromise<BlockWithCreator> {
        return __request(OpenAPI, {
            method: 'PUT',
            url: '/blocks/{id}/taskStatus',
            path: {
                'id': id,
            },
            body: requestBody,
            mediaType: 'application/json',
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Filter
     * @param bookmark
     * @param unread
     * @param unfollow
     * @param upvote
     * @param mention
     * @param searchQuery
     * @param updateFilter
     * @param updateSemanticFilter
     * @returns ThreadsMetaData Get news feed as  data for all threads
     * @throws ApiError
     */
    public static filterNewsfeedGet(
        bookmark: boolean = false,
        unread: boolean = false,
        unfollow: boolean = false,
        upvote: boolean = false,
        mention: boolean = false,
        searchQuery?: string,
        updateFilter: boolean = false,
        updateSemanticFilter: boolean = false,
    ): CancelablePromise<ThreadsMetaData> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/newsfeed',
            query: {
                'bookmark': bookmark,
                'unread': unread,
                'unfollow': unfollow,
                'upvote': upvote,
                'mention': mention,
                'searchQuery': searchQuery,
                'updateFilter': updateFilter,
                'updateSemanticFilter': updateSemanticFilter,
            },
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Search Threads
     * @param query
     * @returns ThreadsModel Search threads by query and get matching threads
     * @throws ApiError
     */
    public static searchThreadsSearchThreadsGet(
        query: string,
    ): CancelablePromise<ThreadsModel> {
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
     * Create Tf
     * @param requestBody
     * @returns UserThreadFlagModel Create a new thread flag
     * @throws ApiError
     */
    public static createTfThreadFlagPost(
        requestBody: CreateUserThreadFlagModel,
    ): CancelablePromise<UserThreadFlagModel> {
        return __request(OpenAPI, {
            method: 'POST',
            url: '/thread/flag',
            body: requestBody,
            mediaType: 'application/json',
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Tt
     * @returns string Get all thread types
     * @throws ApiError
     */
    public static ttThreadTypesGet(): CancelablePromise<Array<string>> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/threadTypes',
        });
    }
    /**
     * Create Th
     * @param requestBody
     * @returns FullThreadInfo Create a new thread
     * @throws ApiError
     */
    public static createThThreadsPost(
        requestBody: CreateThreadModel,
    ): CancelablePromise<FullThreadInfo> {
        return __request(OpenAPI, {
            method: 'POST',
            url: '/threads',
            body: requestBody,
            mediaType: 'application/json',
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Delete Thread
     * @param id
     * @returns boolean Delete a thread by id
     * @throws ApiError
     */
    public static deleteThreadThreadsIdDelete(
        id: string,
    ): CancelablePromise<boolean> {
        return __request(OpenAPI, {
            method: 'DELETE',
            url: '/threads/{id}',
            path: {
                'id': id,
            },
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Get Thread Id
     * @param id
     * @returns FullThreadInfo Get a thread by id
     * @throws ApiError
     */
    public static getThreadIdThreadsIdGet(
        id: string,
    ): CancelablePromise<FullThreadInfo> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/threads/{id}',
            path: {
                'id': id,
            },
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Update Th
     * @param id
     * @param requestBody
     * @returns FullThreadInfo Update a thread by id
     * @throws ApiError
     */
    public static updateThThreadsIdPut(
        id: string,
        requestBody: UpdateThreadTitleModel,
    ): CancelablePromise<FullThreadInfo> {
        return __request(OpenAPI, {
            method: 'PUT',
            url: '/threads/{id}',
            path: {
                'id': id,
            },
            body: requestBody,
            mediaType: 'application/json',
            errors: {
                422: `Validation Error`,
            },
        });
    }
    /**
     * Ti
     * @returns ThreadsInfo Get all thread titles and corresponding types
     * @throws ApiError
     */
    public static tiThreadsInfoGet(): CancelablePromise<ThreadsInfo> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/threadsInfo',
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
    /**
     * Get User Filter Preferences
     * @returns UserFilterPreferenceModel Get user filter preferences
     * @throws ApiError
     */
    public static getUserFilterPreferencesUserNewsFilterGet(): CancelablePromise<UserFilterPreferenceModel> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/user/news-filter',
        });
    }
}
