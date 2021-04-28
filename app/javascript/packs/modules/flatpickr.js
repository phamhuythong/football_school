import flatpickr from 'flatpickr';
import { Vietnamese } from 'flatpickr/dist/l10n/vn.js';
import 'flatpickr/dist/flatpickr.min.css';

flatpickr.localize(Vietnamese);
flatpickr('.js-date-picker', {} );
flatpickr('.js-datetime-picker', { enableTime: true });
flatpickr('.js-time-picker', {enableTime: true, noCalendar: true, dateFormat: 'H:i', time_24hr: true});