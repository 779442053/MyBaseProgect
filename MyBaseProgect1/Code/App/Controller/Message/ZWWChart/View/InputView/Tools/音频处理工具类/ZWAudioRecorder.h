

#import <Foundation/Foundation.h>
#define shortRecord  @"shortRecord"
NS_ASSUME_NONNULL_BEGIN

@interface ZWAudioRecorder : NSObject
+ (instancetype)shareInstanced;

@property (nonatomic,copy) NSString *curRecordFileName;

// 询问录音权限
- (BOOL)canRecord;

// start recording
- (void)startRecordingWithFileName:(NSString *)fileName
                        completion:(void(^)(NSError *error))completion
                             power:(void(^)(float progress))power;
// stop  recording
- (void)stopRecordingWithCompletion:(void(^)(NSString *recordPath))completion;

// pause  UpdateMeters
- (void)pauseUpdateMeters;

// resume UpdateMeters
- (void)resumeUpdateMeters;

// cancel current recording
- (void)cancelCurrentRecording;

// remove current recordFile
- (void)removeCurrentRecordFile;

// voice duration
- (NSUInteger)durationWithVoiceUrl:(NSURL *)voiceUrl;

@end

NS_ASSUME_NONNULL_END
